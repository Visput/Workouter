//
//  AuthenticationView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AuthenticationView: BaseScreenView {
    
    @IBOutlet private weak var headerHeight: NSLayoutConstraint!
    @IBOutlet private weak var headerTopSpace: NSLayoutConstraint!
    @IBOutlet private(set) weak var tryItOutButton: UIButton!
    
    override func didLoad() {
        super.didLoad()
        
        // Configure header view per device size.
        var ratioMultiplier: CGFloat = 2.66
        if UIScreen.mainScreen().sizeType == .iPhone4 {
            ratioMultiplier = 3.50
        }
        headerHeight.constant = frame.size.width / ratioMultiplier
    }
    
    override func keyboardWillShow(notification: NSNotification, keyboardHeight: CGFloat) {
        animateWithKeyboardNotification(notification,
            animations: { () -> Void in
                self.headerTopSpace.constant = -self.headerHeight.constant
                self.tryItOutButton.alpha = 0.0
                self.layoutIfNeeded()
            }, completion: nil)
    }
    
    override func keyboardWillHide(notification: NSNotification, keyboardHeight: CGFloat) {
        animateWithKeyboardNotification(notification,
            animations: { () -> Void in
                self.headerTopSpace.constant = 0
                self.tryItOutButton.alpha = 1.0
                self.layoutIfNeeded()
            }, completion: nil)
    }
}
