//
//  Achievement.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit
import ObjectMapper

final class Achievement: NSObject, Mappable {
    
    enum Type {
        case Undefined
        case FirstCreatedWorkout
        case FirstExecutedWorkout
        case MrWorkouter
    }
    
    /// Achievement type.
    private(set) var type: Type = .Undefined

    /// Achievement name.
    private(set) var name: String = ""
    
    /// Achievement short description.
    private(set) var achievementDescription: String = ""
    
    /// Unique identifier.
    private(set) var identifier: String = ""
    
    /// Number of times when user was awarded with this achievement.
    private(set) var awardCount: Int = 0
    
    /// Achievement progress.
    /// Range [0.0, 1.0]. 1.0 means achievement awarded to user.
    private(set) var progress: Double = 0.0
    
    /// Viewing status.
    /// True if achievement was awarded but not viewed by user yet.
    private(set) var new: Bool = false
    
    /// Small icon name for locked achievement. Used for preview.
    private(set) var lockedStateSmallIconName: String = ""
    
    /// Large icon name for locked achievement. Used for full screen presentation.
    private(set) var lockedStateLargeIconName: String = ""
    
    /// Small icon name for unlocked achievement. Used for preview.
    private(set) var unlockedStateSmallIconName: String = ""
    
    /// Large icon name for unlocked achievement. Used for full screen presentation.
    private(set) var unlockedStateLargeIconName: String = ""
    
    var awarded: Bool {
        get {
            return awardCount >= 1
        }
    }
    
    required init(type: Type,
        name: String,
        achievementDescription: String,
        identifier: String,
        awardCount: Int,
        progress: Double,
        new: Bool,
        lockedStateSmallIconName: String,
        lockedStateLargeIconName: String,
        unlockedStateSmallIconName: String,
        unlockedStateLargeIconName: String) {
            
            self.type = type
            self.name = name
            self.achievementDescription = achievementDescription
            self.identifier = identifier
            self.awardCount = awardCount
            self.progress = progress
            self.new = new
            self.lockedStateSmallIconName = lockedStateSmallIconName
            self.lockedStateLargeIconName = lockedStateLargeIconName
            self.unlockedStateSmallIconName = unlockedStateSmallIconName
            self.unlockedStateLargeIconName = unlockedStateLargeIconName
            super.init()
    }
    
    init?(_ map: Map) {}
    
    func mapping(map: Map) {
        type <- map["type"]
        name <- map["name"]
        achievementDescription <- map["description"]
        identifier <- map["identifier"]
        awardCount <- map["award_count"]
        progress <- map["progress"]
        new <- map["new"]
        lockedStateSmallIconName <- map["locked_state_small_icon_name"]
        lockedStateLargeIconName <- map["locked_state_large_icon_name"]
        unlockedStateSmallIconName <- map["unlocked_state_small_icon_name"]
        unlockedStateLargeIconName <- map["unlocked_state_large_icon_name"]
    }
}

extension Achievement {
    
    func achievementBySettingAwardCount(awardCount: Int) -> Self {
        return self.dynamicType.init(type: type,
            name: name,
            achievementDescription: achievementDescription,
            identifier: identifier,
            awardCount: awardCount,
            progress: progress,
            new: new,
            lockedStateSmallIconName: lockedStateSmallIconName,
            lockedStateLargeIconName: lockedStateLargeIconName,
            unlockedStateSmallIconName: unlockedStateSmallIconName,
            unlockedStateLargeIconName: unlockedStateLargeIconName)
    }
    
    func achievementBySettingProgress(progress: Double) -> Self {
        return self.dynamicType.init(type: type,
            name: name,
            achievementDescription: achievementDescription,
            identifier: identifier,
            awardCount: awardCount,
            progress: progress,
            new: new,
            lockedStateSmallIconName: lockedStateSmallIconName,
            lockedStateLargeIconName: lockedStateLargeIconName,
            unlockedStateSmallIconName: unlockedStateSmallIconName,
            unlockedStateLargeIconName: unlockedStateLargeIconName)
    }
    
    func achievementBySettingNewStatus(new: Bool) -> Self {
        return self.dynamicType.init(type: type,
            name: name,
            achievementDescription: achievementDescription,
            identifier: identifier,
            awardCount: awardCount,
            progress: progress,
            new: new,
            lockedStateSmallIconName: lockedStateSmallIconName,
            lockedStateLargeIconName: lockedStateLargeIconName,
            unlockedStateSmallIconName: unlockedStateSmallIconName,
            unlockedStateLargeIconName: unlockedStateLargeIconName)
    }
}
