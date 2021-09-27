//
//  ChocoViewController.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/23.
//

import UIKit
import RxCocoa
import RxSwift

class ChocoViewController: BaseViewController {
    
    private let tableView = ChocoTableView()
    private let cartButton = UIBarButtonItem()
    private let chocolates = Observable.just(ChocolateType.ofEurope) // just(_:) -> Observable基礎值不會有任何更改，但依舊希望將其作為Observable值訪問
    private let bag = DisposeBag()
}

// MARK: - View Lifecycle
extension ChocoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        confugureTableView()
        setupCartObserver()
        cartButtonTapped()
        configureCell()
        setupCellTapHandling()
    }
    
    private func configureNavigation() {
        
        self.configure(title: .list)
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = cartButton
    }
    
    private func confugureTableView() {

        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
    }
}

// MARK: - Rx setup
private extension ChocoViewController {
    
    // You’ll keep getting these notifications until you either unsubscribe or dispose of your subscription
    func setupCartObserver() {
        // 把購物車中的chocolates變成Observable
        Cart.share.chocolates.asObservable()
            .subscribe(onNext: { [unowned self] chocolates in
                self.cartButton.title = "\(chocolates.count) 🍫"
            })
            .disposed(by: bag)
    }
    
    func cartButtonTapped() {
        
        cartButton.rx.tap
            .subscribe(onNext:{ [unowned self] in
                let destination = CartViewController()
                self.navigationController?.pushViewController(destination, animated: true)
            })
            .disposed(by: bag)
    }
    
    // 配置cell（這邊可以取代掉table view原本的delegate與data source method）
    func configureCell() {
        
        chocolates
        .bind(to: tableView // bind(to:) -> 將chocolate與tableView中每一行的代碼綁定
                  .rx
                  .items(cellIdentifier: ChocoTableViewCell.description(), // items(cellIdentifier:cellType:) -> 傳入cell dentifier跟哪一個cell，
                         cellType: ChocoTableViewCell.self)) { row, chocolate, cell in // 為每個新項目傳入一個block，有關所有row、row裡的chocolate、cell都會回傳
            cell.layoutCell(type: chocolate) // Rx framework calls the dequeuing methods as though your table view had its original data source //

        }
            .disposed(by: bag)
    }
    
    func setupCellTapHandling() {
        
        tableView.rx.modelSelected(ChocolateType.self) // modelSelected(_:) -> 傳入正確的Model，會return一個Observable
            .subscribe(onNext: { [unowned self] chocolate in // 將選定的巧克力加入購物車中
                let newValue = Cart.share.chocolates.value + [chocolate]
                Cart.share.chocolates.accept(newValue)
                
                if let selectedRow = self.tableView.indexPathForSelectedRow {
                    self.tableView.cellForRow(at: selectedRow)
                }
            })
            .disposed(by: bag)
    }
}

