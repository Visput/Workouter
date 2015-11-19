//
//  ProgressButton.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/18/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class ProgressButton: UIButton {

    @IBInspectable dynamic var color: UIColor = UIColor.blackColor() {
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
    
    var valid = true {
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
    
    private var currentColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateAppearance()
    }
}

extension ProgressButton {
    
    private func updateAppearance() {
        if valid {
            currentColor = color
        } else {
            currentColor = invalidStateColor
        }
        
        layer.borderWidth = 1.0
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
        layer.borderColor = colorForState(state).CGColor
        
        setTitleColor(colorForState(state), forState: state)
    }
    
    private func colorForState(state: UIControlState) -> UIColor {
        var resultColor = currentColor
        
        if state == .Selected || state == .Highlighted {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            if currentColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
                resultColor = UIColor(red: max(red - 0.2, 0.0),
                    green: max(green - 0.2, 0.0),
                    blue: max(blue - 0.2, 0.0),
                    alpha: alpha)
            }
            
        } else if state == .Disabled {
            resultColor = disabledStateColor
        }
        
        return resultColor
    }
}
