//
//  ChocoTableView.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/23.
//

import UIKit
import RxCocoa

class ChocoTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        confugure()
        register()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confugure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        separatorStyle = .singleLine
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        rowHeight = 60
    }
    
    func register() {
        register(ChocoTableViewCell.self, forCellReuseIdentifier: ChocoTableViewCell.description())
    }
}
