//
//  ProgressButton.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/18/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class ProgressButton: UIButton {

    var color: UIColor = UIColor.blackColor() {
        didSet {
            fillWithColor(color)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fillWithColor(color)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fillWithColor(color)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
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
    
    private func colorForState(state: UIControlState) -> UIColor {
        var resultColor = color
        
        if state == .Selected || state == .Highlighted {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
                resultColor = UIColor(red: max(red - 0.2, 0.0),
                    green: max(green - 0.2, 0.0),
                    blue: max(blue - 0.2, 0.0),
                    alpha: alpha)
            }
            
        } else if state == .Disabled {
            resultColor = UIColor.grayColor().colorWithAlphaComponent(0.7)
        }
        
        return resultColor
    }
    
    private func fillWithColor(color: UIColor) {
        layer.borderWidth = 1.0
        layer.cornerRadius = 8.0
        
        layer.borderColor = color.CGColor
        setTitleColor(colorForState(.Normal), forState: .Normal)
        setTitleColor(colorForState(.Selected), forState: .Selected)
        setTitleColor(colorForState(.Highlighted), forState: .Highlighted)
        setTitleColor(colorForState(.Disabled), forState: .Disabled)
    }
}
