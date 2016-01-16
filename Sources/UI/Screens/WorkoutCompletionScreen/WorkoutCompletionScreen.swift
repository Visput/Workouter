//
//  WorkoutCompletionScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/15/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class WorkoutCompletionScreen: BaseScreen {
    
    var workout: Workout! {
        didSet {
            guard isViewLoaded() else { return }
            fillViewWithWorkout(workout)
        }
    }
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillViewWithWorkout(workout)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationManager.setNavigationBarHidden(false, animated: animated)
    }
}

extension WorkoutCompletionScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        // Hide button for back navigation as it doesn't make sense
        // to return back to `workout player` screen.
        navigationItem.leftBarButtonItem = nil
    }
    
    @IBAction private func doneButtonDidPress(sender: AnyObject) {
        navigationManager.popScreenAnimated(true)
    }
}

extension WorkoutCompletionScreen {
    
    private func fillViewWithWorkout(workout: Workout) {
        
    }
}
