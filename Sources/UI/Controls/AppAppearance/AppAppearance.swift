//
//  AppAppearance.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/18/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class AppAppearance {
    
    class func applyAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.primaryColor()
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName : UIFont.systemFontOfSize(22.0, weight: UIFontWeightLight),
            NSForegroundColorAttributeName : UIColor.primaryTextColor()
        ]
        UINavigationBar.appearance().shadowImage = UIImage()
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSFontAttributeName : UIFont.systemFontOfSize(17.0, weight: UIFontWeightLight),
                NSForegroundColorAttributeName : UIColor.primaryColor(),
            ],
            forState: .Normal)
        
        ProgressButton.appearance().color = UIColor.primaryColor()
        ProgressButton.appearance().disabledStateColor = UIColor.disabledStateColor()
        ProgressButton.appearance().invalidStateColor = UIColor.invalidStateColor()
    }
}
