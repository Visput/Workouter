//
//  WelcomePageItem.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/3/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

struct WelcomePageItem {
    
    let title: String
    let subtitle: String
    let icon: UIImage
    let index: Int
    
    init(title: String, subtitle: String, icon: UIImage, index: Int) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.index = index
    }
}
