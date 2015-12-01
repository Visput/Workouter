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
    @IBOutlet private weak var contentHeight: NSLayoutConstraint!
    
    override func didLoad() {
        super.didLoad()
        endEditingOnTouch = false
    }
    
    override func keyboardWillShow(notification: NSNotification, keyboardHeight: CGFloat) {
        let maxHeight: CGFloat = 160.0
        headerHeight.constant = min(frame.size.height - contentHeight.constant - keyboardHeight, maxHeight)
    }
}
