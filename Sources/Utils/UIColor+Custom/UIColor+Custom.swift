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
        return UIColor(red: 0.1451, green:0.7804, blue:0.5294, alpha:1.0)
    }
    
    class func primaryTextColor() -> UIColor {
        return UIColor(red: 0.1059, green:0.2157, blue:0.2706, alpha:1.0)
    }
    
    class func secondaryTextColor() -> UIColor {
        return UIColor(red: 0.6549, green:0.6549, blue:0.6549, alpha:1.0)
    }
    
    class func disabledStateColor() -> UIColor {
        return UIColor.grayColor().colorWithAlphaComponent(0.7)
    }
    
    class func invalidStateColor() -> UIColor {
        return UIColor(red: 0.9333, green:0.2392, blue:0.149, alpha:1.0)
    }
    
    class func borderColor() -> UIColor {
        return UIColor(red: 0.5137, green:0.5686, blue:0.6039, alpha:0.7)
    }
    
    class func backgroundColor() -> UIColor {
        return UIColor(red: 0.9294, green:0.9412, blue:0.9569, alpha:1.0)
    }
}
