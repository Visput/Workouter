//
//  TextFieldController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/27/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class TextFieldController: BaseViewController, TextControllerChaining {

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
    
    var keyboardType = UIKeyboardType.Default {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var secureTextEntry = false {
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
            return isViewLoaded() && textField.isFirstResponder()
        }
        set (isActive) {
            guard isViewLoaded() else { return }
            if isActive {
                textField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
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

    private let textMaxLength = 30
    
    @IBOutlet private weak var textField: UITextField!
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

extension TextFieldController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if nextTextController != nil {
            nextTextController!.active = true
        }
        active = false
        
        return true
    }
}

extension TextFieldController {
    
    @IBAction private func textFieldDidChangeText(textField: UITextField) {
        text = textField.text!
        didChangeTextAction?(text: text)
    }
    
    @IBAction private func descriptionButtonDidPress(sender: AnyObject) {
        if valid {
            navigationManager.showInfoDialogWithTitle(descriptionTitle, message: descriptionMessage)
        } else {
            navigationManager.showErrorDialogWithTitle(errorTitle, message: errorMessage)
        }
    }
}

extension TextFieldController {
    
    private func updateViews() {
        if textMaxLength > 0 && text.characters.count > textMaxLength {
            let index = text.startIndex.advancedBy(textMaxLength)
            text = text.substringToIndex(index)
        }
        
        textField.text = text
        textField.keyboardType = keyboardType
        textField.secureTextEntry = secureTextEntry
        textField.autocapitalizationType = .Words
        if secureTextEntry || (keyboardType != .Default && keyboardType != .NamePhonePad) {
            textField.autocapitalizationType = .None
        }
        
        var textColor = UIColor.primaryTextColor()
        var placeholderColor = UIColor.secondaryTextColor()
        var buttonImage = UIImage(named: "icon_info_small")
        if !valid {
            textColor = UIColor.invalidStateColor()
            placeholderColor = UIColor.invalidStateColor()
            buttonImage = UIImage(named: "icon_attention_small")
        }
        
        self.textField.textColor = textColor
        self.textField.attributedPlaceholder = NSAttributedString(string: self.placeholder,
            attributes: [
                NSFontAttributeName : UIFont.systemFontOfSize(17.0, weight: UIFontWeightLight),
                NSForegroundColorAttributeName : placeholderColor
            ])
        
        descriptionButton.setImage(buttonImage, forState: .Normal)
    }
    
    private func configureReturnKey() {
        if nextTextController != nil {
            textField.returnKeyType = .Next
        } else {
            textField.returnKeyType = .Done
        }
    }
}
