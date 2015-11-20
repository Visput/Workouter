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
        return UIColor(red: 0.1506, green:0.7483, blue:0.4551, alpha:1.0)
    }
    
    class func primaryTextColor() -> UIColor {
        return UIColor(red: 0.0841, green:0.1626, blue:0.2083, alpha:1.0)
    }
    
    class func secondaryTextColor() -> UIColor {
        return UIColor(red: 0.5897, green:0.5896, blue:0.5896, alpha:1.0)
    }
    
    class func disabledStateColor() -> UIColor {
        return UIColor ( red: 0.2781, green: 0.2781, blue: 0.2781, alpha: 0.7)
    }
    
    class func invalidStateColor() -> UIColor {
        return UIColor(red: 0.9045, green:0.1463, blue:0.1164, alpha:1.0)
    }
    
    class func borderColor() -> UIColor {
        return UIColor(red: 0.4402, green:0.4958, blue:0.5337, alpha:0.7)
    }
    
    class func backgroundColor() -> UIColor {
        return UIColor(red: 0.9121, green:0.9259, blue:0.9458, alpha:1.0)
    }
}
