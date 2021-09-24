//
//  BaseViewController.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func configure(title: PageTitle) {
        
        navigationItem.title = title.rawValue
    }
}

enum PageTitle: String {
    case list = "List"
    case cart = "Cart"
    case billing = "💳 Info"
    case order = "Order"
}
