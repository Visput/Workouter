//
//  TintButton.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/18/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

 @IBDesignable class TintButton: UIButton {

    @IBInspectable dynamic var primaryColor: UIColor = UIColor.blackColor() {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var secondaryColor: UIColor = UIColor.whiteColor() {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var invalidStateColor: UIColor = UIColor.redColor() {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var disabledStateColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var cornerRadius: CGFloat = 8.0 {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var valid: Bool = true {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var filled: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    override var enabled: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override var selected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override var highlighted: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    private var currentPrimaryColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateAppearance()
    }
}

extension TintButton {
    
    private func updateAppearance() {
        // Colors.
        if valid {
            currentPrimaryColor = primaryColor
        } else {
            currentPrimaryColor = invalidStateColor
        }
        
        var primaryColorForCurrentState = currentPrimaryColor
        
        if state == .Highlighted {
            alpha = 0.4
            
        } else if state == .Disabled {
            primaryColorForCurrentState = disabledStateColor
            alpha = 1.0
            
        } else if state == .Selected {
            alpha = 1.0
            primaryColorForCurrentState = selectedColorForColor(primaryColorForCurrentState)
            
        } else {
            alpha = 1.0
        }
        
        if filled {
            layer.borderColor = primaryColorForCurrentState.CGColor
            setTitleColor(secondaryColor, forState: state)
            backgroundColor = primaryColorForCurrentState
            
        } else {
            layer.borderColor = primaryColorForCurrentState.CGColor
            setTitleColor(primaryColorForCurrentState, forState: state)
            backgroundColor = secondaryColor
        }
        
        // Other.
        layer.borderWidth = 1.0
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
    }
    
    private func selectedColorForColor(color: UIColor) -> UIColor {
        var selectedColor = color
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            selectedColor = UIColor(red: max(red - 0.2, 0.0),
                green: max(green - 0.2, 0.0),
                blue: max(blue - 0.2, 0.0),
                alpha: alpha)
        }
        
        return selectedColor
    }
}
