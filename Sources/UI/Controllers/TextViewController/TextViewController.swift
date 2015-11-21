//
//  TextViewController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit
import VPAttributedFormat

class TextViewController: UIViewController {
    
    var didChangeTextAction: ((text: String) -> ())?
    
    var text = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var placeholder = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var descriptionTitle: String = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var descriptionText: String = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var errorTitle: String = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var errorText: String = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var active: Bool {
        get {
            return isViewLoaded() && textView.isFirstResponder()
        }
        set (isActive) {
            guard isViewLoaded() else { return }
            if isActive {
                textView.becomeFirstResponder()
            } else {
                textView.resignFirstResponder()
            }
        }
    }
    
    var optional = true
    
    var valid = true {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var navigationManager: NavigationManager!
    
    /// Use this property if you need to activate another text controller
    /// when user clicks 'return' key.
    /// If this property is nil then current text controller will be
    /// deactivated when user clicks 'return' key.
    var nextTextViewController: TextViewController? {
        didSet {
            guard isViewLoaded() else { return }
            configureReturnKey()
        }
    }
    
    /// Max number of chars allowed to input.
    /// Set 0 to disable limit.
    /// Equals to 0 by default.
    var textMaxLength = 0 {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var textLimitLabel: UILabel!
    @IBOutlet private weak var descriptionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureReturnKey()
        updateViews()
    }
    
    func validate() -> Bool? {
        guard isViewLoaded() else { return nil }
        valid = optional || !textView.text.isEmpty
        
        return valid
    }
}

extension TextViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        text = textView.text
        didChangeTextAction?(text: text)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // Deactivate controller when user clicks on return key.
        guard text != "\n" else {
            textView.resignFirstResponder()
            if nextTextViewController != nil {
                nextTextViewController!.active = true
            }
            
            return false
        }
        
        return true
    }
}

extension TextViewController {
    
    private func updateViews() {
        if textMaxLength > 0 && text.characters.count > textMaxLength {
            let index = text.startIndex.advancedBy(textMaxLength)
            text = text.substringToIndex(index)
        }
        if text.containsString("\n") {
            text = text.stringByReplacingOccurrencesOfString("\n", withString: " ")
        }
        
        textView.text = text
        
        placeholderLabel.text = placeholder
        placeholderLabel.hidden = !textView.text.isEmpty
        
        textLimitLabel.hidden = textMaxLength <= 0
        withVaList([textMaxLength - textView.text.characters.count]) { pointer in
            textLimitLabel.vp_setAttributedTextFormatArguments(pointer, keepFormat: true)
        }
        
        if valid {
            view.layer.borderColor = UIColor.borderColor().CGColor
        } else {
            view.layer.borderColor = UIColor.invalidStateColor().CGColor
        }
    }
    
    private func configureReturnKey() {
        if nextTextViewController != nil {
            textView.returnKeyType = .Next
        } else {
            textView.returnKeyType = .Done
        }
    }
}

extension TextViewController {
    
    @IBAction func descriptionButtonDidPress(sender: AnyObject) {
        navigationManager.presentInfoDialogWithTitle(descriptionTitle, text: descriptionText)
    }
}
