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
        return 0.2
    }
    
    class func animate(animations: () -> Void) {
        UIView.animateWithDuration(defaultAnimationDuration, animations: animations)
    }
    
    class func animate(animations: () -> Void, completion: (Bool) -> Void) {
        UIView.animateWithDuration(defaultAnimationDuration, animations: animations, completion: completion)
    }
}
