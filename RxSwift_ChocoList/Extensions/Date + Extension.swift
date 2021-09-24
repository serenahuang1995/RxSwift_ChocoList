//
//  Date + Extension.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/24.
//

import Foundation

extension Date {
  var year: Int {
    return Calendar(identifier: .gregorian).component(.year, from: self)
  }
  
  var month: Int {
    return Calendar(identifier: .gregorian).component(.month, from: self)
  }
}
