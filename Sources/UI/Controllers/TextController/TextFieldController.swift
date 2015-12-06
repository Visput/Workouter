//
//  TextFieldController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/27/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class TextFieldController: BaseViewController, TextControllerChaining {

    var didChangeTextAction: ((text: String) -> Void)?
    var didPressDoneAction: (() -> Void)?
    
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
    
    var nextTextController: TextControllerChaining? {
        didSet {
            guard isViewLoaded() else { return }
            configureReturnKey()
        }
    }
    
    var returnKeyTypeForDoneAction = UIReturnKeyType.Done {
        didSet {
            guard isViewLoaded() else { return }
            configureReturnKey()
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
        
        if nextTextController == nil {
            didPressDoneAction?()
        }
        
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
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
            attributes: [
                NSFontAttributeName : UIFont.systemFontOfSize(17.0, weight: UIFontWeightLight),
                NSForegroundColorAttributeName : UIColor.secondaryTextColor()
            ])
        
        var viewBorderColor = UIColor.borderColor().CGColor
        var buttonImage = UIImage(named: "icon_info_green_small")
        if !valid {
            viewBorderColor = UIColor.invalidStateColor().CGColor
            buttonImage = UIImage(named: "icon_attention_red_small")
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
            textField.returnKeyType = .Next
        } else {
            textField.returnKeyType = returnKeyTypeForDoneAction
        }
    }
}
