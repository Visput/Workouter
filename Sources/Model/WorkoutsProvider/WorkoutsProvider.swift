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
    
    let observers = ObserverSet<WorkoutsProviderObserving>()
    private(set) var workouts: [Workout]!
    
    private var workoutsFilePath: String = {
        let workoutsFileName = "/Workouts"
        let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        return documentsDir.stringByAppendingString(workoutsFileName)
    }()
    
    func loadWorkouts() {
        workouts = NSKeyedUnarchiver.unarchiveObjectWithFile(workoutsFilePath) as? [Workout]
        if workouts == nil {
            let step1 = Step(name: "Step 1", description: "Step 1 description", duration: 60)
            let step2 = Step(name: "Step 2", description: "Step 2 description",  duration: 120)
            let steps = [step1, step2];
            workouts = []
            workouts.append(Workout(name: "Workout 1",
                description: "Workout 4 description Workout 4 description Workout 4 description Workout 4 description",
                steps: steps))
            workouts.append(Workout(name: "Workout 2 Workout 2 Workout 2 Workout 2 Workout 2",
                description: "Workout 4 description Workout 4 description Workout 4 description Workout 4 description",
                steps: steps))
            workouts.append(Workout(name: "Workout 3 Workout 3 Workout 3 Workout 3 Workout 3",
                description: "Workout 4 description Workout 4 description Workout 4 description Workout 4 description",
                steps: steps))
            workouts.append(Workout(name: "Workout 4", description: "Workout 4 description", steps: steps))
            workouts.append(Workout(name: "Workout 5", description: "Workout 5 description", steps: steps))
            workouts.append(Workout(name: "Workout 6", description: "Workout 6 description", steps: steps))
            workouts.append(Workout(name: "Workout 3", description: "", steps: steps))
            workouts.append(Workout(name: "Workout 4", description: "Workout 4 description", steps: steps))
            workouts.append(Workout(name: "Workout 5", description: "Workout 5 description", steps: steps))
            workouts.append(Workout(name: "Workout 3", description: "", steps: steps))
            workouts.append(Workout(name: "Workout 4", description: "Workout 4 description", steps: steps))
            workouts.append(Workout(name: "Workout 5", description: "Workout 5 description", steps: steps))
            workouts.append(Workout(name: "Workout 6", description: "Workout 6 description", steps: steps))
        }
    }
    
    func addWorkout(workout: Workout) {
        workouts.append(workout)
        notifyObserversDidUpdateWorkouts()
        commitChanges()
    }
    
    func removeWorkout(workout: Workout) {
        if let index = workouts.indexOf(workout) {
            removeWorkoutAtIndex(index)
        }
    }
    
    func removeWorkoutAtIndex(index: Int) {
        workouts.removeAtIndex(index)
        notifyObserversDidUpdateWorkouts()
        commitChanges()
    }
    
    func moveWorkoutFromIndex(fromIndex: Int, toIndex: Int) {
        let workoutToMove = workouts[fromIndex]
        workouts.removeAtIndex(fromIndex)
        workouts.insert(workoutToMove, atIndex: toIndex)
        notifyObserversDidUpdateWorkouts()
        commitChanges()
    }
    
    func replaceWorkoutAtIndex(index: Int, withWorkout newWorkout: Workout) {
        workouts[index] = newWorkout
        notifyObserversDidUpdateWorkouts()
        commitChanges()
    }
    
    func searchStepsWithRequest(request: StepsSearchRequest) -> [Step] {
        var searchResults = [Step]()
        for workout in workouts {
            for step in workout.steps {
                guard request.searchText == "" ||
                    step.name.containsString(request.searchText) else { continue }
                searchResults.append(step)
            }
        }
        return searchResults
    }
    
    func searchWorkoutsWithRequest(request: WorkoutsSearchRequest) -> [Workout] {
        var searchResults = [Workout]()
        for workout in workouts {
            guard request.searchText == "" ||
                workout.name.containsString(request.searchText) else { continue }
            searchResults.append(workout)
        }
        return searchResults
    }
    
    private func commitChanges() {
        NSKeyedArchiver.archiveRootObject(workouts, toFile: workoutsFilePath)
    }
}

extension WorkoutsProvider {
    
    private func notifyObserversDidUpdateWorkouts() {
        for observer in observers {
            observer.workoutsProvider(self, didUpdateWorkouts: workouts)
        }
    }
}
