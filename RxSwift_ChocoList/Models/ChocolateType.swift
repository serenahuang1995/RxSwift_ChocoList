//
//  ChocolateType.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/23.
//

import Foundation

struct ChocolateType: Equatable, Hashable {
  let priceInDollars: Float
  let countryName: String
  let countryFlagEmoji: String
  
  // An array of chocolate from europe
  static let ofEurope: [ChocolateType] = {
    let belgian = ChocolateType(priceInDollars: 9.99,
                            countryName: "Belgium",
                            countryFlagEmoji: "🇧🇪")
    let british = ChocolateType(priceInDollars: 7.99,
                            countryName: "Great Britain",
                            countryFlagEmoji: "🇬🇧")
    let dutch = ChocolateType(priceInDollars: 8.99,
                          countryName: "The Netherlands",
                          countryFlagEmoji: "🇳🇱")
    let german = ChocolateType(priceInDollars: 6.99,
                           countryName: "Germany", countryFlagEmoji: "🇩🇪")
    let swiss = ChocolateType(priceInDollars: 10.99,
                          countryName: "Switzerland",
                          countryFlagEmoji: "🇨🇭")
    
    return [belgian, british, dutch, german, swiss]
  }()
}
