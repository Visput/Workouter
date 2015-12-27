//
//  WorkoutsService.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

final class WorkoutsProvider: NSObject {
    
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
            let pathToDefaultWorkouts = NSBundle.mainBundle().pathForResource("DefaultWorkouts", ofType: ".json")!
            let defaultWorkoutsJSON = try! NSString(contentsOfFile: pathToDefaultWorkouts, encoding: NSUTF8StringEncoding) as String
            workouts = Mapper<Workout>().mapArray(defaultWorkoutsJSON)
            commitChanges()
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
    
    func replaceWorkout(workout: Workout, withWorkout newWorkout: Workout) {
        for (index, aWorkout) in workouts.enumerate() {
            if aWorkout.identifier == workout.identifier {
                workouts[index] = newWorkout
                notifyObserversDidUpdateWorkouts()
                commitChanges()
                break
            }
        }
    }
    
    func searchStepsWithRequest(request: StepsSearchRequest) -> [Step] {
        var searchResults = [Step]()
        for workout in workouts {
            for step in workout.steps {
                guard (request.includeRestSteps || step.type == .Exercise) &&
                    (request.searchText == "" || step.name.containsString(request.searchText)) else { continue }
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
