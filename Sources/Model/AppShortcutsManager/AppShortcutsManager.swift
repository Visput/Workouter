//
//  AppShortcutsManager.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/27/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AppShortcutsManager: NSObject {
    
    let navigationManager: NavigationManager
    let workoutsProvider: WorkoutsProvider
    
    private var launchedShortcut: UIApplicationShortcutItem?
    
    required init(navigationManager: NavigationManager, workoutsProvider: WorkoutsProvider) {
        self.navigationManager = navigationManager
        self.workoutsProvider = workoutsProvider
        super.init()
        
        self.workoutsProvider.observers.addObserver(self)
    }
    
    func handleShortcutInAppLaunchOptions(launchOptions: [NSObject: AnyObject]?) -> Bool {
        guard let shortcut = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem else { return false }
        launchedShortcut = shortcut
        
        return true
    }
    
    func performActionForLaunchedShortcutIfNeeded() {
        guard launchedShortcut != nil else { return }
        performActionForShortcut(launchedShortcut!)
        launchedShortcut = nil
    }
    
    func performActionForShortcut(shortcut: UIApplicationShortcutItem) -> Bool {
        navigationManager.dismissToRootScreenAnimated(false)
        
        if let workout = workoutsProvider.workoutWithIdentifier(shortcut.type) {
            navigationManager.pushWorkoutDetailsScreenFromMainScreenWithWorkout(workout, animated: false)
        } else {
            navigationManager.pushWorkoutsScreenFromMainScreenWithSourceType(.User, animated: false)
        }
            
        return true
    }
    
    func updateShortcuts() {
        let shortcutsMaxCount = 4
        var shortcuts: [UIApplicationShortcutItem] = []
        
        for index in 0..<shortcutsMaxCount {
            guard index < workoutsProvider.workouts.count else { break }
            let workout = workoutsProvider.workouts[index]
            let shortcut = UIMutableApplicationShortcutItem(type: workout.identifier,
                localizedTitle: workout.name)
            
            shortcuts.append(shortcut)
        }
        
        UIApplication.sharedApplication().shortcutItems = shortcuts
    }
}

extension AppShortcutsManager: WorkoutsProviderObserving {
    
    func workoutsProvider(provider: WorkoutsProvider, didUpdateWorkouts workouts: [Workout]) {
        updateShortcuts()
    }
}
