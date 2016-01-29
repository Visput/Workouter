//
//  BaseView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 3/22/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import Foundation
import UIKit

class BaseView: UIView {
    
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    private var bottomSpaceDefaultValue: CGFloat = 0.0
    
    /// If true then `endEditing:` is called when user touches view.
    /// Used for hiding keyboard.
    var endEditingOnTouch = true
    
    enum AppearanceState {
        case Undefined
        case DidLoad
        case WillAppear
        case DidAppear
        case WillDisappear
        case DidDisappear
    }
    
    var appearanceState = AppearanceState.Undefined
}

extension BaseView {
    
    func didLoad() {
        appearanceState = .DidLoad
    }
    
    func willAppear(animated: Bool) {
        appearanceState = .WillAppear
    }
    
    func didAppear(animated: Bool) {
        appearanceState = .DidAppear
    }
    
    func willDisappear(animated: Bool) {
        appearanceState = .WillDisappear
        endEditing(true)
    }
    
    func didDisappear(animated: Bool) {
        appearanceState = .DidDisappear
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if endEditingOnTouch {
            endEditing(true)
        }
    }
}

extension BaseView {
    
    func keyboardWillShow(notification: NSNotification, keyboardHeight: CGFloat) {
        guard bottomSpace != nil else { return }
        bottomSpaceDefaultValue = bottomSpace!.constant
        
        animateWithKeyboardNotification(notification,
            animations: { 
                self.bottomSpace.constant = keyboardHeight
                
                // Call `layoutIfNeeded` only if view already appeared.
                // It will prevent from unnecessary animations when keyboard and view appear at the same moment.
                if self.appearanceState != .Undefined &&
                    self.appearanceState != .DidLoad &&
                    self.appearanceState != .WillAppear {
                        
                        self.layoutIfNeeded()
                }
            }, completion: nil)
    }
    
    func keyboardDidShow(notification: NSNotification, keyboardHeight: CGFloat) {
        
    }
    
    func keyboardWillHide(notification: NSNotification, keyboardHeight: CGFloat) {
        guard bottomSpace != nil else { return }
        
        animateWithKeyboardNotification(notification,
            animations: { 
                self.bottomSpace.constant = self.bottomSpaceDefaultValue
                self.layoutIfNeeded()
            }, completion: nil)
    }
    
    func keyboardDidHide(notification: NSNotification, keyboardHeight: CGFloat) {
        
    }
    
    func animateWithKeyboardNotification(notification: NSNotification,
        animations: () -> Void,
        completion: ((completed: Bool) -> Void)?) {
            
            let curve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedIntegerValue
            let options = UIViewAnimationOptions(rawValue: curve)
            let duration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: completion)
    }
}
