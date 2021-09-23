//
//  CurrencyFormatter + Extension.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/23.
//

import Foundation

// reference -> https://www.hangge.com/blog/cache/detail_2086.html

enum CurrencyFormatter {
    static let dollarsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency // 以貨幣公用格式輸出，保留2位小數(第3位小數四捨五入)並在數字前面加上貨幣符號
        formatter.currencyCode = "USD"
        return formatter
    }()
}

extension NumberFormatter {
    
    func string(from float: Float) -> String? {
        return string(from: NSNumber(value: float))
    }
}
