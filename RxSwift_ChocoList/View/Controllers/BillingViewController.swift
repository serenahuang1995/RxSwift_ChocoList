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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(title: .billing)
        configureSubViews()
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
