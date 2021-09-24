//
//  CardType.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/24.
//

import Foundation

enum CardType {
    case unowned
    case amex
    case mastercard
    case visa
    case discover
    
    static func fromString(string: String) -> CardType {
        
        guard !string.isEmpty else { return .unowned }
        
        return .amex
    }
}
