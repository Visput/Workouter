//
//  TextDialogFactory.swift
//  Workouter
//
//  Created by Uladzimir Papko on 2/9/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

struct TextDialogFactory {
    
    typealias Style = (dialog: TextDialog) -> Void

    static let Info: Style = { dialog in
        dialog.icon = UIImage(named: "icon_info_green")
        dialog.cancelButtonTitle = NSLocalizedString("Got it", comment: "")
        dialog.confirmButtonHidden = true
    }
    
    static let Error: Style = { dialog in
        dialog.icon = UIImage(named: "icon_attention_red")
        dialog.cancelButtonTitle = NSLocalizedString("Got it", comment: "")
        dialog.confirmButtonHidden = true
    }
    
    static let Save: Style = { dialog in
        dialog.icon = UIImage(named: "icon_attention_red")
        dialog.cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        dialog.confirmButtonTitle = NSLocalizedString("Save", comment: "")
        dialog.confirmButtonHidden = false
    }
    
    let storyboard: UIStoryboard
    
    init(storyboard: UIStoryboard) {
        self.storyboard = storyboard
    }
    
    func dialogWithStyle(style: Style,
        primaryText: String,
        secondaryText: String,
        confirmAction: (() -> Void)? = nil,
        cancelAction: (() -> Void)? = nil) -> TextDialog {
        
            let dialog = storyboard.instantiateViewControllerWithIdentifier(TextDialog.className()) as! TextDialog
            dialog.primaryText = primaryText
            dialog.secondaryText = secondaryText
            dialog.confirmAction = confirmAction
            dialog.cancelAction = cancelAction
            style(dialog: dialog)
            
            
            return dialog
    }
}
