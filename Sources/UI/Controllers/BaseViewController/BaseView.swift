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
    var bottomSpaceDefaultValue: CGFloat = 0.0
    
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
        registerForKeyboardNotifications()
    }
    
    func didAppear(animated: Bool) {
        appearanceState = .DidAppear
    }
    
    func willDisappear(animated: Bool) {
        appearanceState = .WillDisappear
        unregisterFromKeyboardNotifications()
    }
    
    func didDisappear(animated: Bool) {
        appearanceState = .DidDisappear
    }
}

extension BaseView {
    
    func keyboardWillShow(notification: NSNotification, keyboardHeight: CGFloat) {
        guard bottomSpace != nil else { return }
        
        animateWithKeyboardNotification(notification,
            animations: { 
                self.bottomSpace.constant = keyboardHeight
                
                // Call 'layoutIfNeeded' only if view already appeared.
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
    
    func keyboardNotificationDidReceive(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size.height
        
        if notification.name == UIKeyboardWillShowNotification {
            keyboardWillShow(notification, keyboardHeight: keyboardHeight)
        } else if notification.name == UIKeyboardDidShowNotification {
            keyboardDidShow(notification, keyboardHeight: keyboardHeight)
        } else if notification.name == UIKeyboardWillHideNotification {
            keyboardWillHide(notification, keyboardHeight: keyboardHeight)
        } else if notification.name == UIKeyboardDidHideNotification {
            keyboardDidHide(notification, keyboardHeight: keyboardHeight)
        }
    }
    
    private func registerForKeyboardNotifications() {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardNotificationDidReceive:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardNotificationDidReceive:", name: UIKeyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardNotificationDidReceive:", name: UIKeyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: "keyboardNotificationDidReceive:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    private func unregisterFromKeyboardNotifications() {
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }
}
