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

}

extension BaseView {
    
    func willAppear(animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    func didAppear(animated: Bool) {
        
    }
    
    func willDisappear(animated: Bool) {
        
    }
    
    func didDisappear(animated: Bool) {
        unregisterFromKeyboardNotifications()
    }
}

extension BaseView {
    
    func keyboardWillShow(notification: NSNotification, keyboardHeight: CGFloat) {
        
    }
    
    func keyboardDidShow(notification: NSNotification, keyboardHeight: CGFloat) {
        
    }
    
    func keyboardWillHide(notification: NSNotification, keyboardHeight: CGFloat) {
        
    }
    
    func keyboardDidHide(notification: NSNotification, keyboardHeight: CGFloat) {
        
    }
    
    func animateWithKeyboardNotification(notification: NSNotification, animations: () -> (), completion: ((completed: Bool) -> ())?) {
        let duration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let curve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedIntegerValue
        let options = UIViewAnimationOptions(rawValue: curve)
        
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