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
    // BehaviorRelay就是BehaviorSubject的封裝，跟BehaviorSubject一樣有.value()可以使用，但因為Relay不會.error或disposed的問題，不用處理意外狀況
    let chocolates: BehaviorRelay<[ChocolateType]> = BehaviorRelay(value: [])
}

extension Cart {
    
    var totalCost: Float {
        return chocolates.value.reduce(0) { total, chocolate in
            return total + chocolate.priceInDollars
        }
    }
    
    var itemCount: String {
        guard chocolates.value.count > 0 else { return "🚫🍫" }
        
        let setOfChocolates = Set<ChocolateType>(chocolates.value)
        
        let items: [String] = setOfChocolates.map { chocolate in
            let count: Int = chocolates.value.reduce(0) { total, reduceChocolate in
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
