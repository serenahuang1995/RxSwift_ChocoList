//
//  ChocoViewController.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/23.
//

import UIKit
import RxCocoa
import RxSwift

class ChocoViewController: UIViewController {
    
    private let tableView = ChocoTableView()
    private let carButton = UIBarButtonItem()
    
    private let chocolates = ChocolateType.ofEurope

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chocolate List"
        confugure()
    }
    
    private func confugure() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
    }
    

}

extension ChocoViewController: UITableViewDelegate {
    
}

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

