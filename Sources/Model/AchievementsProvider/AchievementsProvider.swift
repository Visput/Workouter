//
//  AchievementsProvider.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit
import ObjectMapper

final class AchievementsProvider: NSObject {

    private(set) var achievements: [Achievement]!
    
    func loadAchievements() {
        achievements = [Achievement]()
        
        for _ in 0..<18 {
            let achievement = Achievement(type: .MrWorkouter,
                name: "",
                achievementDescription: "",
                identifier: "",
                awardCount: 0,
                progress: 0.0,
                new: false,
                lockedStateSmallIconName: "icon_refer_friend_green",
                lockedStateLargeIconName: "",
                unlockedStateSmallIconName: "",
                unlockedStateLargeIconName: "")
            
            achievements.append(achievement)
        }
    }
}
