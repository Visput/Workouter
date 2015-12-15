//
//  SettingsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class SettingsScreen: BaseScreen {
    
    var didCancelAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettingsScreen {
    
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
