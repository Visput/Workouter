//
//  WorkoutsPlaceholderController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/21/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class WorkoutsPlaceholderController: PlaceholderController {

    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var workoutsProvider: WorkoutsProvider {
        return modelProvider.workoutsProvider
    }
    
    @IBAction private func createWorkoutButtonDidPress(sender: AnyObject) {
        let searchRequest = WorkoutsSearchRequest(searchText: "", isTemplates: true, group: .AllWorkouts)
        navigationManager.presentWorkoutTemplatesScreenWithRequest(searchRequest,
            animated: true,
            templateDidSelectAction: { [unowned self] workout in
                
                self.navigationManager.pushWorkoutEditScreenWithWorkout(workout,
                    animated: true,
                    workoutDidEditAction: { [unowned self] workout in
                        
                        self.workoutsProvider.addWorkout(workout)
                        self.navigationManager.dismissScreenAnimated(true)
                        self.navigationManager.pushWorkoutDetailsScreenWithWorkout(workout, animated: true)
                    })
                
            }, templateDidCancelAction: {
                self.navigationManager.dismissScreenAnimated(true)
        })
    }
}
