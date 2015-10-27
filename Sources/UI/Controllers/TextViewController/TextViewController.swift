//
//  TextViewController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UITextViewDelegate {
    @IBOutlet private(set) weak var textView: UITextView!
    @IBOutlet private(set) weak var placeholderLabel: UILabel!
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = !textView.text.isEmpty
    }
}