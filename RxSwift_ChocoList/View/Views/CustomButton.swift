//
//  CustomButton.swift
//  RxSwift_ChocoList
//
//  Created by 黃瀞萱 on 2021/9/24.
//

import UIKit

class ChocolateButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            updateAlphaForEnabledState()
        }
    }
    
    enum ButtonStyle {
        case
            standard,
            warning
    }
    
    //Workaround for enum values not being IBInspectable.
    var isStandard: Bool = false {
        didSet {
            if isStandard {
                style = .standard
            } else {
                style = .warning
            }
        }
    }
    
    private var style: ButtonStyle = .standard {
        didSet {
            updateBackgroundColorForCurrentType()
        }
    }
    
    //MARK: Initialization
    private func commonInit() {
        setTitleColor(.white, for: .normal)
        updateBackgroundColorForCurrentType()
        updateAlphaForEnabledState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    func updateBackgroundColorForCurrentType() {
        
        switch style {
        case .standard:
            backgroundColor = .brown
        case .warning:
            backgroundColor = .red
        }
    }
    
    func updateAlphaForEnabledState() {
        
        if isEnabled {
            alpha = 1
        } else {
            alpha = 0.5
        }
    }
}
