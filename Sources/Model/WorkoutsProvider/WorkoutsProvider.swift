//
//  WorkoutsService.swift
//  SportTime
//
//  Created by Vladimir Popko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit

class WorkoutsProvider: NSObject {
    
    var workouts: [Workout]!
    
    func loadWorkouts() {
        // Hardcoded data
        var step1 = WorkoutStep(name: "Step 1", duration: 60)
        var step2 = WorkoutStep(name: "Step 2", duration: 120)
        var steps = [step1, step2];
        var workout = Workout(name: "Workout 1", steps: steps)
        
        self.workouts = [workout, workout, workout, workout, workout, workout, workout, workout, workout, workout, workout]
    }
}
