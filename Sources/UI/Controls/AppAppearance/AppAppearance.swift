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
            NSFontAttributeName : UIFont.systemFontOfSize(27.0, weight: UIFontWeightThin),
            NSForegroundColorAttributeName : UIColor.primaryTextColor()
        ]
        
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
        let colorView = UIView()
        colorView.backgroundColor = UIColor.transparentPrimaryColor()
        UITableViewCell.appearance().selectedBackgroundView = colorView
        
        // UIPageControl.
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.borderColor()
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.primaryColor()
        
        // TintButton.
        TintButton.appearance().primaryColor = UIColor.primaryColor()
        TintButton.appearance().secondaryColor = UIColor.whiteColor()
        TintButton.appearance().disabledStateColor = UIColor.disabledStateColor()
        TintButton.appearance().invalidStateColor = UIColor.invalidStateColor()
    }
}
