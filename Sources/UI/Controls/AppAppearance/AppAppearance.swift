//
//  AppAppearance.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/18/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AppAppearance {
    
    class func applyAppearance() {
        // UINavigationBar.
        UINavigationBar.appearance().tintColor = UIColor.primaryColor()
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "background_white"), forBarMetrics: .Default)
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName : UIFont.systemFontOfSize(24.0, weight: UIFontWeightThin),
            NSForegroundColorAttributeName : UIColor.primaryTextColor()
        ]
        
        // UIToolbar.
        UIToolbar.appearance().setShadowImage(UIImage(), forToolbarPosition: .Any)
        UIToolbar.appearance().setBackgroundImage(UIImage(named: "background_white"),
            forToolbarPosition: .Any,
            barMetrics: .Default)
        
        // UIBarButtonItem.
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSFontAttributeName : UIFont.systemFontOfSize(17.0, weight: UIFontWeightLight),
                NSForegroundColorAttributeName : UIColor.primaryColor(),
            ],
            forState: .Normal)
        
        // UITextView.
        UITextView.appearance().tintColor = UIColor.primaryColor()
        UITextView.appearance().font = UIFont.systemFontOfSize(17.0, weight: UIFontWeightLight)
        UITextView.appearance().textColor = UIColor.primaryTextColor()
        
        // UITextField.
        UITextField.appearance().tintColor = UIColor.primaryColor()
        UITextField.appearance().defaultTextAttributes = [
            NSFontAttributeName : UIFont.systemFontOfSize(17.0, weight: UIFontWeightLight),
            NSForegroundColorAttributeName : UIColor.primaryTextColor()
        ]
        
        // UISearchBar.
        UISearchBar.appearance().tintColor = UIColor.primaryColor()
        UISearchBar.appearance().searchBarStyle = .Minimal
        UISearchBar.appearance().backgroundColor = UIColor.whiteColor()
        
        // UITableViewCell.
        UITableViewCell.appearance().selectionStyle = .None
        
        // UIPageControl.
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.borderColor()
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.primaryColor()
        
        // UISegmentedControl.
        UISegmentedControl.appearance().tintColor = UIColor.primaryColor()
        
        // TintButton.
        TintButton.appearance().primaryColor = UIColor.primaryColor()
        TintButton.appearance().primaryLightColor = UIColor.superLightPrimaryColor()
        TintButton.appearance().secondaryColor = UIColor.whiteColor()
        TintButton.appearance().invalidStateColor = UIColor.invalidStateColor()
        TintButton.appearance().invalidStateLightColor = UIColor.superLightInvalidStateColor()
    }
}
