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
    @IBOutlet private(set) weak var heartView: UIImageView!
    
    private var heartbeatAnimationEnabled = false
    
    override func didLoad() {
        super.didLoad()
        endEditingOnTouch = false
    }
    
    override func didAppear(animated: Bool) {
        super.didAppear(animated)
        startHeartbeatAnimation()
    }
    
    override func didDisappear(animated: Bool) {
        stopHeartbeatAnimation()
        super.didDisappear(animated)
    }
    
    override func keyboardWillShow(notification: NSNotification, keyboardHeight: CGFloat) {
        let maxHeight: CGFloat = 160.0
        headerHeight.constant = min(frame.size.height - contentHeight.constant - keyboardHeight, maxHeight)
    }
}

extension AuthenticationView {
    
    private func startHeartbeatAnimation() {
        heartbeatAnimationEnabled = true
        animateHeartbeatIfNeeded()
    }
    
    private func stopHeartbeatAnimation() {
        heartbeatAnimationEnabled = false
    }
    
    private func animateHeartbeatIfNeeded() {
        guard heartbeatAnimationEnabled else { return }
        
        UIView.animateWithDuration(0.1,
            delay: 0.0,
            options: .CurveEaseIn,
            animations: { _ in
                self.heartView.bounds.size.width = 45.0
                self.heartView.bounds.size.height = 45.0
                
            }, completion: { _ in
                UIView.animateWithDuration(0.9,
                    delay: 0.0,
                    options: .CurveLinear,
                    animations: { _ in
                        self.heartView.bounds.size.width = 40.0
                        self.heartView.bounds.size.height = 40.0
                    }, completion: { _ in
                        self.animateHeartbeatIfNeeded()
                })
        })
    }
}
