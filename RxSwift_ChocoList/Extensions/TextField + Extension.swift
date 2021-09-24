//
//  TextField + Extension.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/24.
//

import UIKit

class BillingTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.systemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  var valid: Bool = false {
    didSet {
      configureForValid()
    }
  }
  
  var hasBeenExited: Bool = false {
    didSet {
      configureForValid()
    }
  }
  
  override func resignFirstResponder() -> Bool {
    
    hasBeenExited = true
    return super.resignFirstResponder()
  }
  
  private func configureForValid() {
    
    if !valid && hasBeenExited {
      //Only color the background if the user has tried to input things at least once.
      backgroundColor = .red
    } else {
      backgroundColor = .clear
    }
  }
}
