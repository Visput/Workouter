//
//  BaseViewController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/22/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let modelProvider = ModelProvider.provider
    
    var isViewDisplayed: Bool {
        get {
            return isViewLoaded() && view.window != nil
        }
    }
    
    private(set) var keyboardPresented = false
    
    private var baseView: BaseView {
        return view as! BaseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.didLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
        baseView.willAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        baseView.didAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        baseView.willDisappear(animated)
        unregisterFromKeyboardNotifications()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        baseView.didDisappear(animated)
        super.viewDidDisappear(animated)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}

extension BaseViewController {
    
    func keyboardWillShow(notification: NSNotification) {
        // Set true in 'willShow' method instead of 'didShow' method
        // for ability to use this flag during keyboard appearance.
        keyboardPresented = true
    }
    
    func keyboardDidShow(notification: NSNotification) {
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // Set false in 'willHide' method instead of 'didHide' method
        // for ability to use this flag during keyboard disappearance.
        keyboardPresented = false
    }
    
    func keyboardDidHide(notification: NSNotification) {
        
    }
}

extension BaseViewController {
    
    @objc func keyboardNotificationDidReceive(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size.height
        
        if notification.name == UIKeyboardWillShowNotification {
            baseView.keyboardWillShow(notification, keyboardHeight: keyboardHeight)
            keyboardWillShow(notification)
            
        } else if notification.name == UIKeyboardDidShowNotification {
            baseView.keyboardDidShow(notification, keyboardHeight: keyboardHeight)
            keyboardDidShow(notification)
            
        } else if notification.name == UIKeyboardWillHideNotification {
            baseView.keyboardWillHide(notification, keyboardHeight: keyboardHeight)
            keyboardWillHide(notification)
            
        } else if notification.name == UIKeyboardDidHideNotification {
            baseView.keyboardDidHide(notification, keyboardHeight: keyboardHeight)
            keyboardDidHide(notification)
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
