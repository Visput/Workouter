//
//  WorkoutPageContentController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/26/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WorkoutPageContentController: BaseViewController {
    
    var workout: Workout! {
        didSet {
            guard isViewLoaded() else { return }
            fillWithWorkout(workout)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillWithWorkout(workout)
    }

    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
}

extension WorkoutPageContentController {
    
    @IBAction private func actionButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutDetailsScreenWithWorkout(workout, animated: true)
    }
    
    private func fillWithWorkout(workout: Workout) {
        
    }
}
