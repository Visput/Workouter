//
//  AchievementCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AchievementCell: UICollectionViewCell {
    
    @IBOutlet private(set) weak var newStatusView: UIImageView!
    @IBOutlet private(set) weak var iconView: UIImageView!
    
    override var highlighted: Bool {
        didSet {
            alpha = highlighted ? 0.4 : 1.0
        }
    }
    
    func fillWithAchievement(achievement: Achievement) {
        if achievement.awarded {
            iconView.image = UIImage(named: achievement.unlockedStateSmallIconName)
        } else {
            iconView.image = UIImage(named: achievement.lockedStateSmallIconName)
        }
        newStatusView.hidden = !achievement.new
    }
}
