//
//  WorkoutsSearchPlaceholderController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/25/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

class WorkoutsSearchPlaceholderController: PlaceholderController {
    
    @IBOutlet private(set) weak var placeholderLabel: UILabel!

    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var workoutsProvider: WorkoutsProvider {
        return modelProvider.workoutsProvider
    }
    
    @IBAction private func createWorkoutButtonDidPress(sender: AnyObject) {
        navigationManager.presentWorkoutEditScreenWithWorkout(Workout.emptyWorkout(),
            animated: true,
            workoutDidEditAction: { [unowned self] workout in
                self.workoutsProvider.addWorkout(workout)
                self.navigationManager.dismissScreenAnimated(true)
                self.navigationManager.pushWorkoutDetailsScreenWithWorkout(workout, animated: true)
                
            }, workoutDidCancelAction: { [unowned self] in
                self.navigationManager.dismissScreenAnimated(true)
            })
    }
}
