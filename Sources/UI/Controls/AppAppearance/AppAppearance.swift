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
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "background_white"), forBarMetrics: .Default)
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName : UIFont.systemFontOfSize(22.0, weight: UIFontWeightLight),
            NSForegroundColorAttributeName : UIColor.primaryTextColor()
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSFontAttributeName : UIFont.systemFontOfSize(17.0, weight: UIFontWeightLight),
                NSForegroundColorAttributeName : UIColor.primaryColor(),
            ],
            forState: .Normal)
        
        UITextView.appearance().tintColor = UIColor.primaryColor()
        
        UITextField.appearance().tintColor = UIColor.primaryColor()
        UITextField.appearance().defaultTextAttributes = [
            NSFontAttributeName : UIFont.systemFontOfSize(17.0, weight: UIFontWeightLight),
            NSForegroundColorAttributeName : UIColor.primaryTextColor()
        ]
        
        UISearchBar.appearance().tintColor = UIColor.primaryColor()
        UISearchBar.appearance().searchBarStyle = .Minimal
        UISearchBar.appearance().backgroundColor = UIColor.whiteColor()
        
        TintButton.appearance().primaryColor = UIColor.primaryColor()
        TintButton.appearance().secondaryColor = UIColor.whiteColor()
        TintButton.appearance().disabledStateColor = UIColor.disabledStateColor()
        TintButton.appearance().invalidStateColor = UIColor.invalidStateColor()
    }
}
