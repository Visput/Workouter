//
//  StepTemplatesView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/3/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class StepTemplatesView: BaseView {

    @IBOutlet private(set) weak var templatesTableView: UITableView!
    @IBOutlet private weak var bottomSpace: NSLayoutConstraint!
    
    override func willAppear(animated: Bool) {
        super.willAppear(animated)
        deselectSelectedRow()
    }
}

extension StepTemplatesView {
    
    override func keyboardWillShow(notification: NSNotification, keyboardHeight: CGFloat) {
        super.keyboardWillShow(notification, keyboardHeight: keyboardHeight)
        
        animateWithKeyboardNotification(notification, animations: { () -> () in
            self.bottomSpace.constant = keyboardHeight
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    override func keyboardWillHide(notification: NSNotification, keyboardHeight: CGFloat) {
        super.keyboardWillHide(notification, keyboardHeight: keyboardHeight)
        
        animateWithKeyboardNotification(notification, animations: { () -> () in
            self.bottomSpace.constant = 0
            self.layoutIfNeeded()
            }, completion: nil)
    }
}

extension StepTemplatesView {
    
    private func deselectSelectedRow() {
        guard let indexPath = templatesTableView.indexPathForSelectedRow else { return }
        templatesTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
