//
//  AchievementDetailsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/29/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class AchievementDetailsScreen: BaseScreen {

    var didCancelAction: (() -> Void)?
    
    var achievement: Achievement! {
        didSet {
            guard isViewLoaded() else { return }
            fillViewWithAchievement(achievement)
        }
    }
    
    private var achievementDetailsView: AchievementDetailsView {
        return view as! AchievementDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillViewWithAchievement(achievement)
    }
}

extension AchievementDetailsScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.leftBarButtonItem = UIBarButtonItem.greenCancelItemWithAlignment(.Left,
            target: self,
            action: #selector(AchievementDetailsScreen.cancelButtonDidPress(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.greenShareItemWithAlignment(.Right,
            target: self,
            action: #selector(AchievementDetailsScreen.shareButtonDidPress(_:)))
    }
    
    @objc private func cancelButtonDidPress(sender: AnyObject) {
        didCancelAction?()
    }
    
    @objc private func shareButtonDidPress(sender: AnyObject) {
    }
}

extension AchievementDetailsScreen {
    
    private func fillViewWithAchievement(achievement: Achievement) {
        achievementDetailsView.nameLabel.text = achievement.name
        achievementDetailsView.descriptionLabel.text = achievement.achievementDescription
        let iconName = achievement.awarded ? achievement.unlockedStateLargeIconName : achievement.lockedStateLargeIconName
        achievementDetailsView.iconView.image = UIImage(named: iconName)
    }
}
