//
//  OrderViewController.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/24.
//

import UIKit
import RxCocoa
import RxSwift

class OrderViewController: BaseViewController {
    
    private let image = UIImageView()
    private let cardImage = UIImageView()
    private let orderNumberLabel = UILabel()
    private let orderItemLabel = UILabel()
    private let costLabel = UILabel()
    private let paymentLabel = UILabel()
    private let cardType: CardType = .unknown
}

//MARK: -View Lifecycle
extension OrderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(title: .order)
        configureSubViews()
        setupCardIcon()
        setupInfoFromCart()
    }
    
    private func configureSubViews() {
        
        let paymentStackView = UIStackView(arrangedSubviews: [paymentLabel, cardImage])
        paymentStackView.distribution = .fill
        paymentStackView.alignment = .fill
        paymentStackView.axis = .horizontal
        paymentStackView.spacing = 5
        paymentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let orderStackView = UIStackView(arrangedSubviews: [orderNumberLabel, orderItemLabel, costLabel, paymentStackView])
        orderStackView.distribution = .fill
        orderStackView.alignment = .leading
        orderStackView.axis = .vertical
        orderStackView.spacing = 0
        orderStackView.translatesAutoresizingMaskIntoConstraints = false
        
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        
//        let screen = UIScreen.main.bounds
//        let scrollView = UIScrollView(frame: screen)
//        scrollView.isScrollEnabled = true
//        scrollView.contentSize = CGSize(width: screen.width, height: image.frame.height + orderStackView.frame.height + 40)
//        [image, orderStackView].forEach {
//            scrollView.addSubview($0)
//            scrollView.translatesAutoresizingMaskIntoConstraints = false
//        }
        
        [
//         scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//         scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//         scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//         scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         
         image.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
         image.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
         image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         image.widthAnchor.constraint(equalTo: image.heightAnchor, multiplier: 160/133),
            
         orderStackView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
         orderStackView.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 10),
         orderStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
         
         cardImage.heightAnchor.constraint(equalToConstant: 30),
         cardImage.widthAnchor.constraint(equalToConstant: 48)

        ].forEach{ $0.isActive = true }
    }
}

extension OrderViewController {
    
    func setupCardIcon() {
        
        cardImage.image = cardType.image
    }
    
    func setupInfoFromCart() {
    
        let cart = Cart.share
        costLabel.text = CurrencyFormatter.dollarsFormatter.string(from: cart.totalCost)
        orderItemLabel.text = cart.itemCount
    }
}
