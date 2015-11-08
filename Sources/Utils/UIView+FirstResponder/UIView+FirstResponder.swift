//
//  UIView+FirstResponder.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/8/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

extension UIView {
    
    func findFirstResponder() -> UIView? {
        var firstResponder: UIView? = nil
        
        if isFirstResponder() {
            firstResponder = self
        } else {
            for subview in subviews {
                firstResponder = subview.findFirstResponder()
                
                if firstResponder != nil {
                    break
                }
            }
        }
        
        return firstResponder
    }
}