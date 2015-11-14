//
//  AppShortcutsManager.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/27/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class AppShortcutsManager: NSObject {
    
    let navigationManager: NavigationManager
    let workoutsProvider: WorkoutsProvider
    let statisticsProvider: StatisticsProvider
    
    private var launchedShortcut: UIApplicationShortcutItem?
    
    private enum ShortcutIdentifier: String {
        case StartWorkout
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
    
    required init(navigationManager: NavigationManager, workoutsProvider: WorkoutsProvider, statisticsProvider: StatisticsProvider) {
        self.navigationManager = navigationManager
        self.workoutsProvider = workoutsProvider
        self.statisticsProvider = statisticsProvider
        super.init()
        
        self.statisticsProvider.observers.addObserver(self)
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
        guard let shortcutId = ShortcutIdentifier(type: shortcut.type) else { return false }
        
        switch (shortcutId) {
        case .StartWorkout:
            navigationManager.dismissScreenAnimated(false)
            if let workout = statisticsProvider.mostFrequentlyPlayedWorkout {
                navigationManager.pushWorkoutDetailsScreenFromWorkoutsScreenWithWorkout(workout, animated: false)
            } else {
                navigationManager.popToWorkoutsScreenWithSearchActive(false, animated: false)
            }
            break
        case .NewWorkout:
            navigationManager.dismissScreenAnimated(false)
            navigationManager.popToWorkoutsScreenWithSearchActive(false, animated: false)
            navigationManager.presentWorkoutTemplatesScreenWithRequest(WorkoutsSearchRequest.emptyRequest(), animated: false, templateDidSelectAction: { [unowned self] workout in
                self.navigationManager.pushWorkoutEditScreenFromWorkoutsScreenWithWorkout(workout, animated: false) { workout in
                    self.workoutsProvider.addWorkout(workout)
                    self.navigationManager.pushWorkoutDetailsScreenFromPreviousScreenWithWorkout(workout, animated: true)
                }
                self.navigationManager.dismissScreenAnimated(true)
                
            }, templateDidCancelAction: { () -> () in
                self.navigationManager.dismissScreenAnimated(true)
            })
            
            break
        case .SearchWorkout:
            navigationManager.dismissScreenAnimated(false)
            navigationManager.popToWorkoutsScreenWithSearchActive(true, animated: false)
            break
        }
        
        return true
    }
    
    func updateShortcuts() {
        var shortcuts: [UIApplicationShortcutItem] = []
        
        // Start Workout.
        if let workout = statisticsProvider.mostFrequentlyPlayedWorkout {
            let playWorkoutShortcut = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.StartWorkout.type,
                localizedTitle: NSLocalizedString("Start Workout", comment: ""))
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

extension AppShortcutsManager: StatisticsProviderObserving {
    
    func statisticsProvider(provider: StatisticsProvider, didUpdateMostFrequentlyPlayedWorkout workout: Workout?) {
        updateShortcuts()
    }
}
