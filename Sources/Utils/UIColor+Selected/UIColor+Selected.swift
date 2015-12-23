//
//  UIColor+Selected.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/23/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

extension UIColor {

    func selectedColor() -> UIColor {
        var selectedColor = copy() as! UIColor
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            selectedColor = self.dynamicType.init(red: max(red - 0.2, 0.0),
                green: max(green - 0.2, 0.0),
                blue: max(blue - 0.2, 0.0),
                alpha: alpha)
        }
        
        return selectedColor
    }
}
