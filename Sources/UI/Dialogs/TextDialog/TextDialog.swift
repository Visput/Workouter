//
//  TextDialog.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/20/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class TextDialog: BaseDialog {
    
    enum Style {
        case Info
        case Error
    }
    
    var style = Style.Info {
        didSet {
            guard isViewLoaded() else { return }
            updateViews()
        }
    }

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
    
    private var lastFirstResponder: UIResponder?
    
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
    
    @IBAction override func cancelButtonDidPress(sender: AnyObject) {
        super.cancelButtonDidPress(sender)
        lastFirstResponder?.becomeFirstResponder()
        lastFirstResponder = nil
    }
}

extension TextDialog {
    
    private func updateViews() {
        textView.primaryTextLabel.text = primaryText
        textView.secondaryTextLabel.text = secondaryText
        
        if icon != nil {
            textView.iconView.image = icon
        } else {
            switch style {
            case .Info: textView.iconView.image = UIImage(named: "icon_info")
            case .Error: textView.iconView.image = UIImage(named: "icon_attention")
            }
        }
    }
}
