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
    
    override init() {
        navigationManager = NavigationManager()
        workoutsProvider = WorkoutsProvider()
        workoutPlayer = WorkoutPlayer()
        shortcutsManager = AppShortcutsManager(navigationManager: navigationManager, workoutsProvider: workoutsProvider)
        super.init()
    }
}
