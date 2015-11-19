//
//  ProgressButton.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/18/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class ProgressButton: UIButton {

    var color = UIColor.lightPrimaryColor() {
        didSet {
            if valid {
                currentColor = color
            }
        }
    }
    
    var valid = true {
        didSet {
            if valid {
                currentColor = color
            } else {
                currentColor = UIColor.invalidStateColor()
            }
        }
    }
    
    override var enabled: Bool {
        didSet {
            if enabled {
                layer.borderColor = colorForState(.Normal).CGColor
            } else {
                layer.borderColor = colorForState(.Disabled).CGColor
            }
        }
    }
    
    override var selected: Bool {
        didSet {
            if selected {
                layer.borderColor = colorForState(.Selected).CGColor
            } else {
                layer.borderColor = colorForState(.Normal).CGColor
            }
        }
    }
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                layer.borderColor = colorForState(.Highlighted).CGColor
            } else {
                layer.borderColor = colorForState(.Normal).CGColor
            }
        }
    }
    
    private var currentColor: UIColor! {
        didSet {
            applyCurrentColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentColor = color
        applyCurrentColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        currentColor = color
        applyCurrentColor()
    }
}

extension ProgressButton {
    
    private func applyCurrentColor() {
        layer.borderWidth = 1.0
        layer.cornerRadius = 8.0
        
        layer.borderColor = currentColor.CGColor
        setTitleColor(colorForState(.Normal), forState: .Normal)
        setTitleColor(colorForState(.Selected), forState: .Selected)
        setTitleColor(colorForState(.Highlighted), forState: .Highlighted)
        setTitleColor(colorForState(.Disabled), forState: .Disabled)
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
            resultColor = UIColor.disabledStateColor()
        }
        
        return resultColor
    }
}
