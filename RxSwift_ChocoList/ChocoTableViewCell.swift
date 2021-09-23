//
//  ChocoTableViewCell.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/23.
//

import UIKit
import RxSwift
import RxCocoa

class ChocoTableViewCell: UITableViewCell {
    
    private let emojiLabel = UILabel()
    private let countryLable = UILabel()
    private let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubView()        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubView() {
        
        backgroundColor = .clear
        selectionStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [emojiLabel, countryLable])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4

        [ stackView, priceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [ stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
          stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
          stackView.trailingAnchor.constraint(greaterThanOrEqualTo: priceLabel.leadingAnchor),
          
          priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
          priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
          priceLabel.heightAnchor.constraint(equalToConstant: 21)

        ].forEach { $0 .isActive = true}
    }
    
    func layoutCell(type: ChocolateType) {
        
        emojiLabel.text = "🍫" + type.countryFlagEmoji
        countryLable.text = type.countryName
        priceLabel.text = CurrencyFormatter.dollarsFormatter.string(for: type.priceInDollars)
    }

}
