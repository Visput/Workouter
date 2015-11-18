//
//  UIColor+Custom.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/18/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func primaryColor() -> UIColor {
        return UIColor(red: 0.137, green:0.4319, blue:0.5122, alpha:1.0)
    }
    
    class func lightPrimaryColor() -> UIColor {
        return UIColor(red: 0.3504, green:0.7259, blue:0.8202, alpha:1.0)
    }
    
    class func secondaryColor() -> UIColor {
        return UIColor(red: 0.0549, green:0.4549, blue:0.8235, alpha:1.0)
    }
    
    class func primaryTextColor() -> UIColor {
        return UIColor(red: 0.3059, green:0.4157, blue:0.4706, alpha:1.0)
    }
    
    class func secondaryTextColor() -> UIColor {
        return UIColor(red: 0.6549, green:0.6549, blue:0.6549, alpha:1.0)
    }
    
    class func disabledStateColor() -> UIColor {
        return UIColor.grayColor().colorWithAlphaComponent(0.7)
    }
    
    class func invalidStateColor() -> UIColor {
        return UIColor(red: 0.9216, green:0.2314, blue:0.1922, alpha:1.0)
    }
}
