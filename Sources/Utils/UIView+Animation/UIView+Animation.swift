//
//  UIView+Animation.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/22/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

extension UIView {
    
    class var defaultAnimationDuration: NSTimeInterval {
        return 0.3
    }
    
    class func animateWithDefaultDuration(animations: () -> Void) {
        UIView.animateWithDuration(defaultAnimationDuration, animations: animations)
    }
    
    class func animateWithDefaultDuration(animations: () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(defaultAnimationDuration, animations: animations, completion: completion)
    }
    
    class func animateWithDefaultDuration(options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(defaultAnimationDuration,
            delay: 0.0,
            options: options,
            animations: animations,
            completion: completion)
    }
}
