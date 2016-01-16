//
//  MagicBoxSettingsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/15/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class MagicBoxSettingsScreen: BaseScreen {
    
    var didCancelAction: (() -> Void)?
}

extension MagicBoxSettingsScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.leftBarButtonItem = UIBarButtonItem.greenCancelItemWithAlignment(.Left,
            target: self,
            action: Selector("cancelButtonDidPress:"))
    }
    
    @objc private func cancelButtonDidPress(sender: AnyObject) {
        didCancelAction?()
    }
}
