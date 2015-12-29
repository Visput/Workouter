//
//  ServicesProvider.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/20/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import Foundation

final class ModelProvider: NSObject {
    
    static let provider = ModelProvider()
    
    let accountManager: AccountManager
    let navigationManager: NavigationManager
    let workoutsProvider: WorkoutsProvider
    let workoutPlayer: WorkoutPlayer
    let shortcutsManager: AppShortcutsManager
    let statisticsProvider: StatisticsProvider
    let achievementsProvider: AchievementsProvider
    
    override init() {
        accountManager = AccountManager()
        navigationManager = NavigationManager()
        workoutsProvider = WorkoutsProvider()
        workoutPlayer = WorkoutPlayer()
        statisticsProvider = StatisticsProvider(workoutsProvider: workoutsProvider)
        achievementsProvider = AchievementsProvider()
        
        shortcutsManager = AppShortcutsManager(navigationManager: navigationManager,
            workoutsProvider: workoutsProvider,
            statisticsProvider: statisticsProvider)
        
        super.init()
    }
}
