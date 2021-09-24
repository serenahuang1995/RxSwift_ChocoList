//
//  String + Extension.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/24.
//

import Foundation

extension String {
    
    //MARK: -Credit Card
    var areAllCharactersNumbers: Bool {
      let nonNumberCharacterSet = CharacterSet.decimalDigits.inverted
      return (rangeOfCharacter(from: nonNumberCharacterSet) == nil)
    }
    
    var isLuhnValid: Bool {
        guard areAllCharactersNumbers else { return false }
        
        let reversed = self.reversed().map { String($0) }
        
        var sum = 0
        for (index, element) in reversed.enumerated() {
            guard let digit = Int(element) else { return false }
            
            if index % 2 == 1 {
                switch digit {
                case 9:
                    sum += 9
                default:
                    sum += ((digit * 2) % 9)
                }
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }
    
    var removingSpace: String {
        return replacingOccurrences(of: " ", with: "")
    }
    
    func integerValue(ofFirstCharacters count: Int) -> Int? {
        guard areAllCharactersNumbers, count <= self.count else { return nil }
        
        let substring = prefix(count)
        guard let integerValue = Int(substring) else { return nil }
        
        return integerValue
    }
    
    //MARK: -Expiration Date
    var addingSlash: String {
        guard count > 2 else { return self }
        
        let index = index(startIndex, offsetBy: 2)
        let firstTwo = prefix(upTo: index)
        let rest = suffix(from: index)
        
        return firstTwo + "/" + rest
    }
    
    var removingSlash: String {
        return removingSpace.replacingOccurrences(of: "/", with: "")
    }
    
    var isDateValid: Bool {
        let noSlash = removingSlash
        
        // 必須是mmyyy還有必須是全數字
        guard noSlash.count == 6 && noSlash.areAllCharactersNumbers else { return false }
        
        let index = index(startIndex, offsetBy: 2)
        let monthString = prefix(upTo: index)
        let yearString = suffix(from: index)
        
        guard let month = Int(monthString),
              let year = Int(yearString) else { return false }
        
        // 月份必須是介於1月～12月
        guard month >= 1 && month <= 12 else { return false }
        
        let now = Date()
        let currentYear = now.year
        
        // 超過現在年份 -> 無效
        guard year >= currentYear else { return false }
        
        if year == currentYear {
          let currentMonth = now.month
            
          // 超過現在月份(current year) -> 無效
          guard month >= currentMonth else { return false }
        }
        return true
    }
}
