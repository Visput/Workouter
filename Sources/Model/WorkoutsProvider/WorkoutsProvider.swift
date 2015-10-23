//
//  WorkoutsService.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit
import Foundation

class WorkoutsProvider: NSObject {
    
    private(set) var workouts: [Workout]!
    
    private var workoutsFilePath: String = {
        let workoutsFileName = "/Workouts"
        let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        return documentsDir.stringByAppendingString(workoutsFileName)
    }()
    
    func loadWorkouts() {
        workouts = NSKeyedUnarchiver.unarchiveObjectWithFile(workoutsFilePath) as? [Workout]
        if workouts == nil {
            let step1 = WorkoutStep(name: "Step 1", duration: 60)
            let step2 = WorkoutStep(name: "Step 2", duration: 120)
            let steps = [step1, step2];
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
        if let index = workouts.indexOf(workout) {
            deleteWorkoutAtIndex(index)
        }
    }
    
    func deleteWorkoutAtIndex(index: Int) {
        workouts.removeAtIndex(index)
        commitChanges()
    }
    
    func moveWorkoutFromIndex(fromIndex: Int, toIndex: Int) {
        let workoutToMove = workouts[fromIndex]
        workouts.removeAtIndex(fromIndex)
        workouts.insert(workoutToMove, atIndex: toIndex)
        commitChanges()
    }
    
    private func commitChanges() {
        NSKeyedArchiver.archiveRootObject(workouts, toFile: workoutsFilePath)
    }
}
