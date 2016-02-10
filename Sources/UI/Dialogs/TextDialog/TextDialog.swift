//
//  TextDialog.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/20/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class TextDialog: BaseDialog {

    var primaryText = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var secondaryText = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var icon: UIImage? {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var confirmButtonTitle = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var cancelButtonTitle = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var confirmButtonHidden = false {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var confirmAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    private var lastFirstResponder: UIResponder?
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var textView: TextDialogView {
        return view as! TextDialogView
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        lastFirstResponder = UIApplication.sharedApplication().keyWindow?.findFirstResponder()
        lastFirstResponder?.resignFirstResponder()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        lastFirstResponder = UIApplication.sharedApplication().keyWindow?.findFirstResponder()
        lastFirstResponder?.resignFirstResponder()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction private func confirmButtonDidPress(sender: AnyObject) {
        textView.animateHidingWithCompletion { _ in
            self.navigationManager.dismissDialog()
            self.dismissAction?()
            self.confirmAction?()
        }
        lastFirstResponder?.becomeFirstResponder()
        lastFirstResponder = nil
    }
    
    @IBAction private func cancelButtonDidPress(sender: AnyObject) {
        textView.animateHidingWithCompletion { _ in
            self.navigationManager.dismissDialog()
            self.dismissAction?()
            self.cancelAction?()
        }
        lastFirstResponder?.becomeFirstResponder()
        lastFirstResponder = nil
    }
    
    @IBAction override func dismissButtonDidPress(sender: AnyObject) {
        cancelButtonDidPress(sender)
    }
}

extension TextDialog {
    
    private func updateViews() {
        textView.primaryTextLabel.text = primaryText
        textView.secondaryTextLabel.text = secondaryText
        textView.iconView.image = icon
        textView.confirmButton.setTitle(confirmButtonTitle, forState: .Normal)
        textView.cancelButton.setTitle(cancelButtonTitle, forState: .Normal)
        
        textView.confirmButton.hidden = confirmButtonHidden
        textView.confirmButton.filled = !confirmButtonHidden
        textView.cancelButton.filled = confirmButtonHidden
    }
}
