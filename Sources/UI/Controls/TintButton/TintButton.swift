//
//  TintButton.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/18/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class TintButton: UIButton {

    @IBInspectable dynamic var primaryColor: UIColor = UIColor.blackColor() {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var primaryLightColor: UIColor = UIColor.whiteColor() {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var secondaryColor: UIColor = UIColor.whiteColor() {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var invalidStateColor: UIColor = UIColor.redColor() {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var invalidStateLightColor: UIColor = UIColor.whiteColor() {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var cornerRadius: CGFloat = 8.0 {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var borderVisible: Bool = true {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var valid: Bool = true {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable dynamic var filled: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    override var enabled: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override var selected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override var highlighted: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    private var currentPrimaryColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyDefaultValues()
        updateAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyDefaultValues()
        updateAppearance()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateAppearance()
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        updateAppearance()
    }
    
    override func setAttributedTitle(title: NSAttributedString?, forState state: UIControlState) {
        super.setAttributedTitle(title, forState: state)
        updateAppearance()
    }
}

extension TintButton {
    
    func updateAppearance() {
        guard enabled else {
            fatalError("Disabled state is deprecated for better user experience.")
        }
        
        // Layer.
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
        layer.borderWidth = borderVisible ? 1.0 : 0.0
        
        // Colors.
        if valid {
            currentPrimaryColor = primaryColor
        } else {
            currentPrimaryColor = invalidStateColor
        }
        
        var primaryColorForCurrentState = currentPrimaryColor
        
        if state == .Highlighted {
            alpha = 0.4
            
        } else if state == .Selected {
            alpha = 1.0
            primaryColorForCurrentState = primaryColorForCurrentState.selectedColor()
            
        } else {
            alpha = 1.0
        }
        
        // Filling animation.
        let buttonBorderColor = primaryColorForCurrentState.CGColor
        var buttonTitleColor = primaryColorForCurrentState
        
        // Set light color to background if button unfilled.
        var buttonBackgroundColor = valid ? primaryLightColor : invalidStateLightColor
        
        if filled {
            buttonTitleColor = secondaryColor
            buttonBackgroundColor = primaryColorForCurrentState
        }
        
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.duration = UIView.defaultAnimationDuration
        borderColorAnimation.fromValue = layer.borderColor
        borderColorAnimation.toValue = buttonBorderColor
        layer.addAnimation(borderColorAnimation, forKey: nil)
        layer.borderColor = buttonBorderColor
        
        UIView.animateWithDefaultDuration {
            self.setTitleColor(buttonTitleColor, forState: self.state)
            self.backgroundColor = buttonBackgroundColor
        }
        
        // Layout
        let titleWidth = titleLabel != nil ? titleLabel!.intrinsicContentSize().width : 0.0
        let imageWidth = imageView != nil ? imageView!.frame.size.width : 0.0
        
        if titleWidth != 0 && imageWidth != 0 {
            contentHorizontalAlignment = .Left
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0.0, right: 0.0)
            
            let widthInset = (frame.size.width - titleWidth) / 2.0 - imageWidth - contentEdgeInsets.left
            titleEdgeInsets = UIEdgeInsets(top: 0, left: widthInset, bottom: 0.0, right: 0.0)
        }
    }
    
    func applyDefaultValues() {
        adjustsImageWhenHighlighted = false
    }
}
