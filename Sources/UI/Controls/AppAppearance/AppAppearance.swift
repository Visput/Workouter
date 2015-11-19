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
            NSFontAttributeName : UIFont.systemFontOfSize(22.0),
            NSForegroundColorAttributeName : UIColor.primaryTextColor()
        ]
        
        ProgressButton.appearance().color = UIColor.lightPrimaryColor()
        ProgressButton.appearance().disabledStateColor = UIColor.disabledStateColor()
        ProgressButton.appearance().invalidStateColor = UIColor.invalidStateColor()
    }
}
