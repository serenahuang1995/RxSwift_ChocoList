//
//  Cart.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/23.
//

import Foundation
import RxSwift
import RxCocoa

class Cart {
    
    static let share = Cart()
    var chocolates: [ChocolateType] = []
}

extension Cart {
    
    var totalCost: Float {
        return chocolates.reduce(0) { total, chocolate in
            return total + chocolate.priceInDollars
        }
    }
    
    var itemCount: String {
        guard chocolates.count > 0 else { return "🚫🍫" }
        
        let setOfChocolates = Set<ChocolateType>(chocolates)
        
        let items: [String] = setOfChocolates.map { chocolate in
            let count: Int = chocolates.reduce(0) { total, reduceChocolate in
                if chocolate == reduceChocolate {
                    return total + 1
                }
                return total
            }
            return "\(chocolate.countryFlagEmoji)🍫: \(count)"
        }
        return items.joined(separator: "\n")
    }
}
