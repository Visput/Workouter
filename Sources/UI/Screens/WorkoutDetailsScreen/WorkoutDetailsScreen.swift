//
//  WorkoutDetailsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

final class WorkoutDetailsScreen: BaseScreen {
    
    var workout: Workout! {
        didSet {
            guard isViewLoaded() else { return }
            fillViewWithWorkout(workout)
        }
    }
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var workoutDetailsView: WorkoutDetailsView {
        return view as! WorkoutDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillViewWithWorkout(workout)
    }
}

extension WorkoutDetailsScreen {
    
    @IBAction private func startWorkoutButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutPlayerScreenWithWorkout(workout, animated: true)
    }
    
    @IBAction private func editWorkoutButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutEditScreenFromCurrentScreenWithWorkout(workout,
            showWorkoutDetailsOnCompletion: false,
            animated: true,
            workoutDidEditAction: { [unowned self] workout in
                self.workout = workout
        })
    }
}

extension WorkoutDetailsScreen {
    
    private func fillViewWithWorkout(workout: Workout) {
        
    }
}
