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
        let numberOfPieces = 9
        var images = [UIImage]()
        for i in 1 ... numberOfPieces {
            images.append(UIImage(named: "icon_info_to_attention_small\(i)")!)
        }
        return images
    }()
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        // Configure colors in `didMoveToWindow` to override UIAppearance configuration.
        configureColors()
    }
    
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
            animationImageView.animationImages = animationImages
            animationImageView.startAnimating()
        }
    }
    
    override func applyDefaultValues() {
        super.applyDefaultValues()
        
        animationImageView = UIImageView(frame: bounds)
        animationImageView.contentMode = .Center
        animationImageView.autoresizingMask = [.FlexibleWidth, .FlexibleWidth]
        animationImageView.animationRepeatCount = 1
        animationImageView.animationDuration = 0.2
        addSubview(animationImageView)
        
        borderVisible = false
    }
    
    private func configureColors() {
        primaryColor = UIColor.clearColor()
        primaryLightColor = UIColor.clearColor()
        secondaryColor = UIColor.clearColor()
        invalidStateColor = UIColor.clearColor()
        invalidStateLightColor = UIColor.clearColor()
    }
}
