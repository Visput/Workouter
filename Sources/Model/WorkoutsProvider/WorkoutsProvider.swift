//
//  WorkoutsService.swift
//  Workouter
//
//  Created by Vladimir Popko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit
import Foundation

class WorkoutsProvider: NSObject {
    
    private(set) var workouts: [Workout]!
    
    private var workoutsFilePath: String = {
        let workoutsFileName = "Workouts"
        let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        return documentsDir.stringByAppendingPathComponent(workoutsFileName)
    }()
    
    func loadWorkouts() {
        workouts = NSKeyedUnarchiver.unarchiveObjectWithFile(workoutsFilePath) as? [Workout]
        if workouts == nil {
            var step1 = WorkoutStep(name: "Step 1", duration: 60)
            var step2 = WorkoutStep(name: "Step 2", duration: 120)
            var steps = [step1, step2];
            workouts = []
            workouts.append(Workout(name: "Workout 1", steps: steps))
            workouts.append(Workout(name: "Workout 2", steps: steps))
            workouts.append(Workout(name: "Workout 3", steps: steps))
            workouts.append(Workout(name: "Workout 4", steps: steps))
            workouts.append(Workout(name: "Workout 5", steps: steps))
            workouts.append(Workout(name: "Workout 6", steps: steps))
        }
    }
    
    func deleteWorkout(workout: Workout) {
        if let index = find(workouts, workout) {
            deleteWorkoutAtIndex(index)
        }
    }
    
    func deleteWorkoutAtIndex(index: Int) {
        workouts.removeAtIndex(index)
        commitChanges()
    }
    
    func moveWorkout(#fromIndex: Int, toIndex: Int) {
        let workoutToMove = workouts[fromIndex]
        workouts.removeAtIndex(fromIndex)
        workouts.insert(workoutToMove, atIndex: toIndex)
        commitChanges()
    }
    
    private func commitChanges() {
        NSKeyedArchiver.archiveRootObject(workouts, toFile: workoutsFilePath)
    }
}
