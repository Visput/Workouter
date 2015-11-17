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
    
    /// Max number of chars allowed to input.
    /// Set 0 to disable limit.
    /// Equals to 0 by default.
    var textMaxLength = 0 {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var text: String = "" {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }
    
    var placeholder: String = "" {
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
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var textLimitLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use default placeholder/text from storyboard/xib.
        if placeholder.isEmpty && placeholderLabel.text != nil {
            placeholder = placeholderLabel.text!
        }
        if text.isEmpty {
            text = textView.text
        }
        
        updateViews()
    }
    
    private func updateViews() {
        if textMaxLength > 0 && text.characters.count > textMaxLength {
            let index = text.startIndex.advancedBy(textMaxLength)
            text = text.substringToIndex(index)
        }
        
        textView.text = text
        
        placeholderLabel.text = placeholder
        placeholderLabel.hidden = !textView.text.isEmpty
        
        textLimitLabel.hidden = textMaxLength <= 0
        withVaList([textView.text.characters.count, textMaxLength]) { pointer in
            textLimitLabel.vp_setAttributedTextFormatArguments(pointer, keepFormat: true)
        }
    }
}

extension TextViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        text = textView.text
    }
}
