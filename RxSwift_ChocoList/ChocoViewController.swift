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
    private let chocolates = ChocolateType.ofEurope
    private let bag = DisposeBag()
}

// MARK: - View Lifecycle
extension ChocoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        confugureTableView()
        
        cartButton.rx.tap
            .subscribe(
            onNext:{ [weak self] in
                let destination = CartViewController()
                self?.navigationController?.pushViewController(destination, animated: true)
            })
            .disposed(by: bag)
    }
    
    // 每次進到VC就會更新一次
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartButton()
    }
    
    private func configureNavigation() {
        
        self.configure(title: .list)
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = cartButton
    }
    
    private func confugureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
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
    
}

// MARK: - update cart count immediately
private extension ChocoViewController {
    func updateCartButton() {
        cartButton.title = "\(Cart.share.chocolates.count) 🍫"
    }
}

// MARK: - TableView Delegate
extension ChocoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)
        
        let chocolate = chocolates[indexPath.row]
        Cart.share.chocolates.append(chocolate)
        updateCartButton()
    }
}

// MARK: - TableView DataSource
extension ChocoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return chocolates.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChocoTableViewCell.debugDescription(), for: indexPath)
        guard let chocoCell = cell as? ChocoTableViewCell else { return cell }
        chocoCell.layoutCell(type: chocolates[indexPath.row])
        return chocoCell
    }
}

