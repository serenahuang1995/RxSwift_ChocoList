//
//  BillingViewController.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/24.
//

import UIKit
import RxSwift
import RxCocoa

class BillingViewController: BaseViewController {
    
    private let cardTextField = BillingTextField()
    private let expTextField = BillingTextField()
    private let cvvTextField = BillingTextField()
    private let cardImage = UIImageView()
    private let purchaseButton = UIButton()
    private let throttleIntervalInMilliseconds = 100
    private let bag = DisposeBag()
    private let cardType: BehaviorRelay<CardType> = BehaviorRelay(value: .unknown)
}

//MARK: -View Lifecycle
extension BillingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(title: .billing)
        configureSubViews()
        setupCardImageDisplay()
        setupTextChangeHandling()
    }
    
    private func configureSubViews() {
        
        let numberStackView = UIStackView(arrangedSubviews: [cardTextField, cardImage])
        let infoStackView = UIStackView(arrangedSubviews: [expTextField, cvvTextField])
        [numberStackView, infoStackView].forEach {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 5
        }

        let finalStackView = UIStackView(arrangedSubviews: [numberStackView, infoStackView, purchaseButton])
        finalStackView.axis = .vertical
        finalStackView.alignment = .leading
        finalStackView.distribution = .fill
        finalStackView.spacing = 10

        [finalStackView, numberStackView, infoStackView, cardImage, purchaseButton, expTextField, cvvTextField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        [finalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         finalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         finalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

         numberStackView.trailingAnchor.constraint(equalTo: finalStackView.trailingAnchor),
         numberStackView.leadingAnchor.constraint(equalTo: finalStackView.leadingAnchor),

         infoStackView.trailingAnchor.constraint(equalTo: finalStackView.trailingAnchor),
         infoStackView.leadingAnchor.constraint(equalTo: finalStackView.leadingAnchor),

         cardImage.widthAnchor.constraint(equalToConstant: 48),
         cardImage.heightAnchor.constraint(equalToConstant: 30),

         cvvTextField.widthAnchor.constraint(equalTo: expTextField.widthAnchor, multiplier: 0.5)

        ].forEach{ $0.isActive = true }
    }
}

//MARK: -Rx setup
extension BillingViewController {
    
    func setupCardImageDisplay() {
        // 將Observer添加到BehaviorRelay
        cardType.asObservable()
            .subscribe(onNext: { [unowned self] cardType in // Subscribe to that Observable to reveal changes to cardType
                self.cardImage.image = cardType.image
            })
            .disposed(by: bag)
    }
    
    func setupTextChangeHandling() {
        
        // Credit Card
        let creditCardValid = cardTextField
            .rx
            .text // 將文本字段的內容作為Observable返回
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            // 限制輸入根據定義的間隔時間設置要運行的驗證，scheduler參數是一個更先進的理念，但短期的版本是，它依賴於一個線程，要將所有內容保留在主線程上所以使用MainScheduler
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                // 通過將受限制的輸入應用於validate(cardText:)來轉換受限制的輸入，如果卡片輸入有效，則觀察到的Bool最終值為true
                self.validate(cardText: $0)
            }
        
        creditCardValid
            .subscribe(onNext: { [unowned self] in // 獲取創建的Observable值並訂閱，根據傳入的值更新文本字段的有效性
                self.cardTextField.valid = $0
            })
            .disposed(by: bag)
        
        // Expiration Date
        let expirationDateValid = expTextField
            .rx
            .text
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.validate(expirationDateText: $0)
            }
        expirationDateValid
            .subscribe(onNext: { [unowned self] in
                self.expTextField.valid = $0
            })
            .disposed(by: bag)
        
        // CVV
        let cvvValid = cvvTextField
            .rx
            .text
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.validate(cvvText: $0)
                
            }
        cvvValid
            .subscribe(onNext: { [unowned self] in
                self.cvvTextField.valid = $0
            })
            .disposed(by: bag)
        
        // 是true或false具體取決於所有三個輸入是否有效
        let everythingValid = Observable.combineLatest(creditCardValid, expirationDateValid, cvvValid) {
            $0 && $1 && $2 //All must be true
        }
        
        // 按鈕僅在所有信用卡詳細信息都有效時才啟用
        everythingValid.bind(to: purchaseButton.rx.isEnabled)
                       .disposed(by: bag)
    }
}

//MARK: - Validation methods
private extension BillingViewController {
    
  // 判斷卡號是否有效
  func validate(cardText: String?) -> Bool {
    
    guard let cardText = cardText else { return false }
    
    let noWhitespace = cardText.removingSpace
    
    updateCardType(using: noWhitespace)
    formatCardNumber(using: noWhitespace)
    advanceIfNecessary(noSpacesCardNumber: noWhitespace)
    
    guard cardType.value != .unknown else { return false } //Definitely not valid if the type is unknown.

    guard noWhitespace.isLuhnValid else { return false } // Failed luhn validation
    
    return noWhitespace.count == cardType.value.expectedDigits
  }
  
  // 判斷日期是否有效
  func validate(expirationDateText expiration: String?) -> Bool {
    
    guard let expiration = expiration else { return false }
    let strippedSlashExpiration = expiration.removingSlash
    
    formatExpirationDate(using: strippedSlashExpiration)
    advanceIfNecessary(expirationNoSpacesOrSlash: strippedSlashExpiration)
    
    return strippedSlashExpiration.isDateValid
  }
  
  // 判斷cvv是否有效
  func validate(cvvText cvv: String?) -> Bool {
    
    guard let cvv = cvv else { return false }
    guard cvv.areAllCharactersNumbers else { return false } // Someone snuck a letter in here.
    
    dismissIfNecessary(cvv: cvv)
    
    return cvv.count == cardType.value.cvvDigits
  }
}

//MARK: -Single-serve helper functions
private extension BillingViewController {
    
  func updateCardType(using noSpacesNumber: String) {
    
    cardType.accept(CardType.fromString(string: noSpacesNumber))
  }
  
  func formatCardNumber(using noSpacesCardNumber: String) {
    
    cardTextField.text = cardType.value.format(noSpaces: noSpacesCardNumber)
  }
  
  func advanceIfNecessary(noSpacesCardNumber: String) {
    
    if noSpacesCardNumber.count == cardType.value.expectedDigits {
      expTextField.becomeFirstResponder()
    }
  }
  
  func formatExpirationDate(using expirationNoSpacesOrSlash: String) {
    
    expTextField.text = expirationNoSpacesOrSlash.addingSlash
  }
  
  func advanceIfNecessary(expirationNoSpacesOrSlash: String) {
    
    if expirationNoSpacesOrSlash.count == 6 { //mmyyyy
      cvvTextField.becomeFirstResponder()
    }
  }
  
  func dismissIfNecessary(cvv: String) {
    
    if cvv.count == cardType.value.cvvDigits {
      let _ = cvvTextField.resignFirstResponder()
    }
  }
}
