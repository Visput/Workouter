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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "cancelButtonDidPress:")
        tapRecognizer.delegate = self
        baseView.addGestureRecognizer(tapRecognizer)
    }
    
    @IBAction func cancelButtonDidPress(sender: AnyObject) {
        navigationManager.dismissDialogAnimated(true)
    }
}

extension BaseDialog: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        // Prevent dialog dismissing when user touches content view.
        let touchPoint = touch.locationInView(baseView)
        guard !CGRectContainsPoint(baseView.contentView.frame, touchPoint) else { return false }
        
        return true
    }
}
