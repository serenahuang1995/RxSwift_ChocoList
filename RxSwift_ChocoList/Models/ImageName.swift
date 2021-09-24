//
//  ImageName.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/24.
//

import UIKit

enum ImageName: String {
  case
  amex,
  discover,
  mastercard,
  visa,
  unknownCard
  
  var image: UIImage? {
    guard let image = UIImage(named: rawValue) else {
      return nil
    }
    
    return image
  }
}
