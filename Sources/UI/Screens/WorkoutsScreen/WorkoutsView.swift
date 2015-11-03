//
//  WorkoutsView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 3/21/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import Foundation
import UIKit

class WorkoutsView: BaseView {
    
    enum ViewMode {
        case Standard
        case Edit
        
        func title() -> String {
            switch self {
            case .Standard:
                return NSLocalizedString("Edit", comment: "")
            case .Edit:
                return NSLocalizedString("Done", comment: "")
            }
        }
    }
    
    var mode = ViewMode.Standard {
        didSet {
            switch mode {
            case .Edit:
                workoutsTableView.setEditing(true, animated: true)
                break
            case .Standard:
                workoutsTableView.setEditing(false, animated: true)
            }
            modeButtonItem.title = mode.title()
        }
    }
    
    func switchMode() {
        switch mode {
        case .Standard:
            mode = .Edit
        case .Edit:
            mode = .Standard
        }
    }
    
    @IBOutlet private(set) weak var workoutsTableView: UITableView!
    @IBOutlet private weak var modeButtonItem: UIBarButtonItem!
    @IBOutlet private weak var bottomSpace: NSLayoutConstraint!
}

extension WorkoutsView {
 
    override func willAppear(animated: Bool) {
        super.willAppear(animated)
        deselectSelectedRow()
    }
}

extension WorkoutsView {
    
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

extension WorkoutsView {
    
    private func deselectSelectedRow() {
        guard let indexPath = workoutsTableView.indexPathForSelectedRow else { return }
        workoutsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}