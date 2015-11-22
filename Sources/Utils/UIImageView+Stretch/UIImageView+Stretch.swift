//
//  UIImageView+Stretch.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/21/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

extension UIImageView {
    
    @IBInspectable var imageStretchable: Bool {
        
        get {
            guard image != nil else { return false }
            return UIEdgeInsetsEqualToEdgeInsets(image!.capInsets, capInsetsToStretchForImage(image!))
        }
        
        set (imageStretchable) {
            guard image != nil else { return }
            
            var capInsets = UIEdgeInsetsZero
            if imageStretchable {
                capInsets = capInsetsToStretchForImage(image!)
            }
            image = image!.resizableImageWithCapInsets(capInsets)
        }
    }
    
    private func capInsetsToStretchForImage(image: UIImage) -> UIEdgeInsets {
        let imageSize = image.size
        return UIEdgeInsetsMake(imageSize.height / 2, imageSize.width / 2, imageSize.height / 2 + 1, imageSize.width / 2 + 1)
    }
}
