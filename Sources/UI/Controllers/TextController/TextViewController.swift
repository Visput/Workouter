//
//  TextViewController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit
import VPAttributedFormat

class TextViewController: BaseViewController, TextControllerChaining {
    
    var didChangeTextAction: ((text: String) -> Void)?
    
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
    
    var descriptionTitle = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var descriptionMessage = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
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
    
    var nextTextController: TextControllerChaining? {
        didSet {
            guard isViewLoaded() else { return }
            configureReturnKey()
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
    
    private(set) var valid = true {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    private var errorTitle = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    private var errorMessage = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var textLimitLabel: UILabel!
    @IBOutlet private weak var descriptionButton: UIButton!
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureReturnKey()
        updateViews()
    }
    
    func setInvalidWithErrorTitle(errorTitle: String, errorMessage: String) {
        self.errorTitle = errorTitle
        self.errorMessage = errorMessage
        valid = false
    }
    
    func setValid() {
        self.errorTitle = ""
        self.errorMessage = ""
        valid = true
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
            if nextTextController != nil {
                nextTextController!.active = true
            }
            
            return false
        }
        
        return true
    }
}

extension TextViewController {
    
    @IBAction private func descriptionButtonDidPress(sender: AnyObject) {
        if valid {
            navigationManager.showInfoDialogWithTitle(descriptionTitle, message: descriptionMessage)
        } else {
            navigationManager.showErrorDialogWithTitle(errorTitle, message: errorMessage)
        }
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
        
        var viewBorderColor = UIColor.borderColor().CGColor
        var buttonImage = UIImage(named: "icon_info_small")
        if !valid {
            viewBorderColor = UIColor.invalidStateColor().CGColor
            buttonImage = UIImage(named: "icon_attention_small")
        }
        
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.duration = UIView.defaultAnimationDuration
        borderColorAnimation.fromValue = view.layer.borderColor
        borderColorAnimation.toValue = viewBorderColor
        view.layer.addAnimation(borderColorAnimation, forKey: nil)
        view.layer.borderColor = viewBorderColor
        
        descriptionButton.setImage(buttonImage, forState: .Normal)
    }
    
    private func configureReturnKey() {
        if nextTextController != nil {
            textView.returnKeyType = .Next
        } else {
            textView.returnKeyType = .Done
        }
    }
}
