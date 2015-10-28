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
    
    let screenManager: ScreenManager
    let workoutsProvider: WorkoutsProvider
    let workoutPlayer: WorkoutPlayer
    let shortcutsManager: AppShortcutsManager
    
    override init() {
        screenManager = ScreenManager()
        workoutsProvider = WorkoutsProvider()
        workoutPlayer = WorkoutPlayer()
        shortcutsManager = AppShortcutsManager(screenManager: screenManager, workoutsProvider: workoutsProvider)
        super.init()
    }
}
