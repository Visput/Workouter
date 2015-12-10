//
//  ProgressViewItem.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/9/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

struct ProgressViewItem {
    
    let trackTintColor: UIColor
    let progressTintColor: UIColor
    let progress: CGFloat
    
    init(trackTintColor: UIColor, progressTintColor: UIColor, progress: CGFloat) {
        self.trackTintColor = trackTintColor
        self.progressTintColor = progressTintColor
        self.progress = progress
    }
}
