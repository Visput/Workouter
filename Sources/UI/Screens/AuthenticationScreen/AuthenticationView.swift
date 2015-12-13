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
    @IBOutlet private weak var heartViewWidth: NSLayoutConstraint!
    @IBOutlet private weak var heartViewHeight: NSLayoutConstraint!
    @IBOutlet private(set) weak var heartView: UIImageView!
    
    private var heartbeatAnimationEnabled = false
    
    override func didLoad() {
        super.didLoad()
        endEditingOnTouch = false
    }
    
    override func didAppear(animated: Bool) {
        super.didAppear(animated)
        
        // Execute animation after delay.
        // Reason: immediate execution on screen appearance results in not smooth animation.
        executeAfterDelay(0.3) {
            self.startHeartbeatAnimation()
        }
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
        
        // Set beat frequency.
        let beatsPerSec = 1.0
        
        // Set beat amplitude.
        let inToOutRatio: CGFloat = 1.125
        
        // Execute animation.
        let inAnimationDuration = 0.1 / beatsPerSec
        let outAnimationDuration = 1 / beatsPerSec - inAnimationDuration
        
        UIView.animateWithDuration(inAnimationDuration,
            delay: 0.0,
            options: .CurveEaseIn,
            animations: { _ in
                self.heartView.bounds.size.width = self.heartViewWidth.constant * inToOutRatio
                self.heartView.bounds.size.height = self.heartViewHeight.constant * inToOutRatio
                
            }, completion: { _ in
                UIView.animateWithDuration(outAnimationDuration,
                    delay: 0.0,
                    options: .CurveLinear,
                    animations: { _ in
                        self.heartView.bounds.size.width = self.heartViewWidth.constant
                        self.heartView.bounds.size.height = self.heartViewHeight.constant
                    }, completion: { _ in
                        self.animateHeartbeatIfNeeded()
                })
        })
    }
}
