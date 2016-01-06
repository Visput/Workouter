//
//  AchievementCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AchievementCell: BaseCollectionViewCell {
    
    @IBOutlet private(set) weak var newStatusView: UIImageView!
    @IBOutlet private(set) weak var iconView: UIImageView!
    
    func fillWithAchievement(achievement: Achievement) {
        if achievement.awarded {
            iconView.image = UIImage(named: achievement.unlockedStateSmallIconName)
        } else {
            iconView.image = UIImage(named: achievement.lockedStateSmallIconName)
        }
        newStatusView.hidden = !achievement.new
    }
}
