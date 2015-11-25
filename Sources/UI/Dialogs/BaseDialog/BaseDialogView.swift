//
//  BaseDialogView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/20/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class BaseDialogView: BaseView {    
    
    @IBOutlet private(set) weak var contentView: UIView!
    @IBOutlet private(set) weak var contentViewBottomSpace: NSLayoutConstraint!
    
    private(set) var backgroundView: UIView!
    
    override func didLoad() {
        super.didLoad()
        configureBackgroundView()
        contentViewBottomSpace.constant = -contentView.bounds.size.height
    }
}

extension BaseDialogView {
    
    func animateShowingWithCompletion(completion: (Bool) -> Void) {
        let animationDuration = 0.7
        
        UIView.animateWithDuration(animationDuration) {
            self.backgroundView.alpha = 0.5
        }
        
        UIView.animateWithDuration(animationDuration,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 10.0,
            options: [.CurveEaseInOut],
            animations: {
                self.contentViewBottomSpace.constant = 0.0
                self.layoutIfNeeded()
            }, completion: completion)
    }
    
    func animateHidingWithCompletion(completion: (Bool) -> Void) {
        let animationDuration = 0.4
        
        UIView.animateWithDuration(animationDuration,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { () -> Void in
                self.backgroundView.alpha = 0.0
                self.contentViewBottomSpace.constant = -self.contentView.bounds.size.height
                self.layoutIfNeeded()
            }, completion: completion)
    }
}

extension BaseDialogView {
    
    private func configureBackgroundView() {
        backgroundColor = UIColor.clearColor()
        
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.frame = bounds
        backgroundView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        backgroundView.alpha = 0.0
        addSubview(backgroundView)
        sendSubviewToBack(backgroundView)
    }
}
