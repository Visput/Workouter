//
//  BaseDialog.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/20/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class BaseDialog: BaseViewController {

    private var baseView: BaseDialogView {
        return view as! BaseDialogView
    }
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .OverCurrentContext
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .OverCurrentContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGestureRecognizers()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        baseView.animateShowingWithCompletion {_ in }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        guard presentingViewController != nil else { return super.preferredStatusBarStyle() }
        if presentingViewController!.isKindOfClass(UINavigationController) {
            let navigationController = presentingViewController! as! UINavigationController
            return navigationController.topViewController!.preferredStatusBarStyle()
        } else {
            return presentingViewController!.preferredStatusBarStyle()
        }
    }
    
    @IBAction func cancelButtonDidPress(sender: AnyObject) {
        baseView.animateHidingWithCompletion {_ in
            self.navigationManager.dismissDialog()
        }
    }
}

extension BaseDialog: UIGestureRecognizerDelegate {
    
    func configureGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("cancelButtonDidPress:"))
        tapRecognizer.delegate = self
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("cancelButtonDidPress:"))
        swipeRecognizer.direction = .Down
        
        baseView.backgroundView.addGestureRecognizer(tapRecognizer)
        baseView.addGestureRecognizer(swipeRecognizer)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        // Prevent dialog dismissing when user touches content view.
        let touchPoint = touch.locationInView(baseView.backgroundView)
        guard !CGRectContainsPoint(baseView.contentView.frame, touchPoint) else { return false }
        
        return true
    }
}
