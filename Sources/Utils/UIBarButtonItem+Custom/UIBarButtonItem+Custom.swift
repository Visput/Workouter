//
//  UIBarButtonItem+Custom.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/6/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    class func greenBackItemWithAlignment(alignment: UIControlContentHorizontalAlignment,
        target: AnyObject,
        action: Selector) -> Self {
            
            let barButton = barButtonWithImageNamed("icon_back_green",
                horizontalAlignment: alignment,
                target: target,
                action: action)
            
            return self.init(customView: barButton)
    }
    
    class func redBackItemWithAlignment(alignment: UIControlContentHorizontalAlignment,
        target: AnyObject,
        action: Selector) -> Self {
            
            let barButton = barButtonWithImageNamed("icon_back_red",
                horizontalAlignment: alignment,
                target: target,
                action: action)
            
            return self.init(customView: barButton)
    }
    
    class func greenDoneItemWithAlignment(alignment: UIControlContentHorizontalAlignment,
        target: AnyObject,
        action: Selector) -> Self {
            
            let barButton = barButtonWithImageNamed("icon_done_green",
                horizontalAlignment: alignment,
                target: target,
                action: action)
            
            return self.init(customView: barButton)
    }
    
    class func greenCancelItemWithAlignment(alignment: UIControlContentHorizontalAlignment,
        target: AnyObject,
        action: Selector) -> Self {
            
            let barButton = barButtonWithImageNamed("icon_cancel_green",
                horizontalAlignment: alignment,
                target: target,
                action: action)
            
            return self.init(customView: barButton)
    }
    
    class func redCancelItemWithAlignment(alignment: UIControlContentHorizontalAlignment,
        target: AnyObject,
        action: Selector) -> Self {
            
            let barButton = barButtonWithImageNamed("icon_cancel_red",
                horizontalAlignment: alignment,
                target: target,
                action: action)
            
            return self.init(customView: barButton)
    }
    
    class func greenEditItemWithAlignment(alignment: UIControlContentHorizontalAlignment,
        target: AnyObject,
        action: Selector) -> Self {
            
            let barButton = barButtonWithImageNamed("icon_edit_green",
                horizontalAlignment: alignment,
                target: target,
                action: action)
            
            return self.init(customView: barButton)
    }
    
    class func greenPlusItemWithAlignment(alignment: UIControlContentHorizontalAlignment,
        target: AnyObject,
        action: Selector) -> Self {
            
            let barButton = barButtonWithImageNamed("icon_plus_green",
                horizontalAlignment: alignment,
                target: target,
                action: action)
            
            return self.init(customView: barButton)
    }
    
    class func greenAccountItemWithAlignment(alignment: UIControlContentHorizontalAlignment,
        target: AnyObject,
        action: Selector) -> Self {
            
            let barButton = barButtonWithImageNamed("icon_account_green",
                horizontalAlignment: alignment,
                target: target,
                action: action)
            
            return self.init(customView: barButton)
    }
    
    class func greenGameSettingsItemWithAlignment(alignment: UIControlContentHorizontalAlignment,
        target: AnyObject,
        action: Selector) -> Self {
            
            let barButton = barButtonWithImageNamed("icon_game_settings_green",
                horizontalAlignment: alignment,
                target: target,
                action: action)
            
            return self.init(customView: barButton)
    }
    
    class func greenShareItemWithAlignment(alignment: UIControlContentHorizontalAlignment,
        target: AnyObject,
        action: Selector) -> Self {
            
            let barButton = barButtonWithImageNamed("icon_share_green",
                horizontalAlignment: alignment,
                target: target,
                action: action)
            
            return self.init(customView: barButton)
    }
    
    private class func barButtonWithImageNamed(imageName: String,
        horizontalAlignment: UIControlContentHorizontalAlignment,
        target: AnyObject,
        action: Selector) -> AlphaButton {
            
            let button = AlphaButton(type: .Custom)
            button.setImage(UIImage(named: imageName), forState: .Normal)
            button.frame = CGRectMake(0.0, 0.0, 60.0, 44.0)
            button.contentHorizontalAlignment = horizontalAlignment
            // Set bottom inset for correct allignment between bar button and bar title.
            button.contentEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 4.0, 0.0)
            button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
            
            return button
    }
}
