//
//  ServicesProvider.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/20/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import Foundation

class ModelProvider: NSObject {
    
    static let provider = ModelProvider()
    
    let navigationManager: NavigationManager
    let workoutsProvider: WorkoutsProvider
    let workoutPlayer: WorkoutPlayer
    let shortcutsManager: AppShortcutsManager
    let statisticsProvider: StatisticsProvider
    
    override init() {
        navigationManager = NavigationManager()
        workoutsProvider = WorkoutsProvider()
        workoutPlayer = WorkoutPlayer()
        statisticsProvider = StatisticsProvider(workoutsProvider: workoutsProvider)
        
        shortcutsManager = AppShortcutsManager(navigationManager: navigationManager,
            workoutsProvider: workoutsProvider,
            statisticsProvider: statisticsProvider)
        
        super.init()
    }
}
