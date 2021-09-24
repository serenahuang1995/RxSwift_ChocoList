//
//  CartViewController.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/23.
//

import UIKit
import RxCocoa
import RxSwift

class CartViewController: BaseViewController {
    
    private let checkButton = UIButton()
    private let resetButton = UIButton()
    private let totalItemLabel = UILabel()
    private let costLabel = UILabel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(title: .cart)
        configureSubViews()
        resetButtonTapped()
        configureFromCart()
        checkButtonTapped()
    }
    
    private func configureSubViews() {
        
        let stackView = UIStackView(arrangedSubviews: [totalItemLabel, costLabel])
        stackView.alignment = .bottom
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        totalItemLabel.font = UIFont.systemFont(ofSize: 30)
        totalItemLabel.baselineAdjustment = .alignBaselines
        totalItemLabel.lineBreakMode = .byTruncatingTail
        
        [stackView, checkButton, resetButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
         
         checkButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
         checkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         checkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         
         resetButton.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 8),
         resetButton.trailingAnchor.constraint(equalTo: checkButton.trailingAnchor),
         resetButton.leadingAnchor.constraint(equalTo: checkButton.leadingAnchor),
         
         costLabel.heightAnchor.constraint(equalToConstant: 21)
        ].forEach { $0.isActive = true }
        
        checkButton.backgroundColor = .brown
        checkButton.setTitle("Check!", for: .normal)
        checkButton.setTitleColor(.white, for: .normal)

        resetButton.backgroundColor = .yellow
        resetButton.setTitle("Reset!", for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
    }
}

extension CartViewController {
    
    func resetButtonTapped() {
        
        resetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                Cart.share.chocolates = []
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
    
    func checkButtonTapped() {
        
        checkButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let destination = BillingViewController()
                self?.navigationController?.pushViewController(destination, animated: true)
            })
            .disposed(by: bag)
    }
}

extension CartViewController {
    
    func configureFromCart() {
        
        let cart = Cart.share
        totalItemLabel.text = cart.itemCount
        costLabel.text = CurrencyFormatter.dollarsFormatter.string(from: cart.totalCost)
        
        checkButton.isEnabled = cart.totalCost > 0
    }
}
