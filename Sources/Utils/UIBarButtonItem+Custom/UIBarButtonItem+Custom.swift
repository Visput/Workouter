//
//  UIBarButtonItem+Custom.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/6/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    class func backItemWithTarget(target: AnyObject, action: Selector) -> Self {
        let barButton = barButtonWithImageNamed("icon_back_green",
            target: target,
            action: action)
        
        return self.init(customView: barButton)
    }
    
    private class func barButtonWithImageNamed(imageName: String,
        target: AnyObject,
        action: Selector) -> TintButton {
            
            let button = TintButton(type: .Custom)
            button.borderVisible = false
            button.setImage(UIImage(named: imageName), forState: .Normal)
            button.frame = CGRectMake(0.0, 0.0, 60.0, 44.0)
            button.contentHorizontalAlignment = .Left
            // Set bottom inset for correct allignment between bar button and bar title.
            button.contentEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 4.0, 0.0)
            button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
            
        return button
    }
}
