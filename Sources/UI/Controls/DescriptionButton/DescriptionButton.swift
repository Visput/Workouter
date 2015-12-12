//
//  DescriptionButton.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/12/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class DescriptionButton: TintButton {
    
    override var valid: Bool {
        willSet {
            needAnimate = valid != newValue
        }
    }
    
    private var needAnimate = false
    private var animationImageView: UIImageView!
    
    private lazy var defaultAnimationImages: [UIImage] = {
        let numberOfPieces = 7
        var images = [UIImage]()
        images.append(UIImage(named: "icon_info_small_green")!)
        for var i = 1; i <= numberOfPieces; i++ {
            images.append(UIImage(named: "icon_info_to_attention_small_\(i)")!)
        }
        images.append(UIImage(named: "icon_attention_small_red")!)
        return images
    }()
    
    override func updateAppearance() {
        super.updateAppearance()
        
        var buttonImage = UIImage(named: "icon_attention_small_red")
        var animationImages = defaultAnimationImages
        
        if valid {
            buttonImage = UIImage(named: "icon_info_small_green")
            animationImages = defaultAnimationImages.reverse()
        }
        
        setImage(buttonImage, forState: .Normal)
        
        if needAnimate {
            needAnimate = false
            
            // Animate switching to new validation state.
            animationImageView.hidden = false
            animationImageView.animationImages = animationImages
            animationImageView.startAnimating()
            
            // Reduce waiting time to avoid image view flashing when animation is completed.
            let waitingTime = animationImageView.animationDuration * Double(animationImages.count - 1) / Double(animationImages.count)
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * waitingTime))
            // Hide animation view when animation is completed.
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.animationImageView.hidden = true
            })
        }
    }
    
    override func applyDefaultValues() {
        super.applyDefaultValues()
        
        animationImageView = UIImageView(frame: bounds)
        animationImageView.backgroundColor = UIColor.whiteColor()
        animationImageView.contentMode = .Center
        animationImageView.autoresizingMask = [.FlexibleWidth, .FlexibleWidth]
        animationImageView.hidden = true
        animationImageView.animationRepeatCount = 1
        animationImageView.animationDuration = 0.2
        addSubview(animationImageView)
        
        primaryColor = UIColor.clearColor()
        secondaryColor = UIColor.clearColor()
        invalidStateColor = UIColor.clearColor()
        borderVisible = false
    }
}
