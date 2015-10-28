//
//  AppShortcutsManager.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/27/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class AppShortcutsManager: NSObject {
    
    let screenManager: ScreenManager
    let workoutsProvider: WorkoutsProvider
    
    private enum ShortcutIdentifier: String {
        case PlayWorkout
        case NewWorkout
        case SearchWorkout
        
        init?(type: String) {
            guard let type = type.componentsSeparatedByString(".").last else { return nil }
            self.init(rawValue: type)
        }

        var type: String {
            return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    required init(screenManager: ScreenManager, workoutsProvider: WorkoutsProvider) {
        self.screenManager = screenManager
        self.workoutsProvider = workoutsProvider
        super.init()
    }
    
    func performActionForShortcutInAppLaunchOptions(launchOptions: [NSObject: AnyObject]?) -> Bool {
        guard let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem else { return false }
        
        return performActionForShortcut(shortcutItem)
    }
    
    func performActionForShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
        guard let shortcutId = ShortcutIdentifier(type: shortcutItem.type) else { return false }
        
        switch (shortcutId) {
        case .PlayWorkout:
            if workoutsProvider.workouts.count > 0 {
                let workout = workoutsProvider.workouts[0]
                screenManager.pushWorkoutDetailsScreenFromWorkoutsScreenWithWorkout(workout, animated: false)
            } else {
                screenManager.popToWorkoutsScreenAnimated(false)
            }
            break
        case .NewWorkout:
            screenManager.pushWorkoutEditScreenFromWorkoutsScreenWithWorkout(nil, animated: false) { [unowned self] workout in
                self.workoutsProvider.addWorkout(workout)
            }
            break
        case .SearchWorkout:
            break
        }
        
        return true
    }
    
    func updateShortcuts() {
        var shortcuts: [UIApplicationShortcutItem] = []
        
        // Play Workout.
        if workoutsProvider.workouts.count > 0 {
            let workout = workoutsProvider.workouts[0]
            let playWorkoutShortcut = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.PlayWorkout.type,
                localizedTitle: NSLocalizedString("Play Workout", comment: ""))
            playWorkoutShortcut.localizedSubtitle = workout.name
            shortcuts.append(playWorkoutShortcut)
        }
        
        // New Workout.
        let newWorkoutShortcut = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.NewWorkout.type,
            localizedTitle: NSLocalizedString("New Workout", comment: ""))
        shortcuts.append(newWorkoutShortcut)
        
        // Search Workout.
        let searchWorkoutShortcut = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.SearchWorkout.type,
            localizedTitle: NSLocalizedString("Search Workout", comment: ""))
        shortcuts.append(searchWorkoutShortcut)
        
        UIApplication.sharedApplication().shortcutItems = shortcuts
    }
}
