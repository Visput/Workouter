//
//  SettingsItem.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/18/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

struct SettingsItem {

    let title: String
    let icon: UIImage
    let action: () -> Void
    
    init(title: String, icon: UIImage, action: () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
}
