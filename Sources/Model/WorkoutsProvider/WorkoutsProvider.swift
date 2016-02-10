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

enum WorkoutsGroup {
    case UserWorkouts
    case DefaultWorkouts
    case AllWorkouts
}

final class WorkoutsProvider: NSObject {
    
    let observers = ObserverSet<WorkoutsProviderObserving>()
    
    private(set) var userWorkouts: [Workout]!
    private(set) var defaultWorkouts: [Workout]!
    
    private var userWorkoutsFilePath: String = {
        let userWorkoutsFileName = "/Workouts"
        let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        return documentsDir.stringByAppendingString(userWorkoutsFileName)
    }()
    
    func loadWorkouts() {
        userWorkouts = NSKeyedUnarchiver.unarchiveObjectWithFile(userWorkoutsFilePath) as? [Workout]
        if userWorkouts == nil {
            userWorkouts = []
            commitChanges()
        }
        
        let pathToDefaultWorkouts = NSBundle.mainBundle().pathForResource("DefaultWorkouts", ofType: ".json")!
        let defaultWorkoutsJSON = try! NSString(contentsOfFile: pathToDefaultWorkouts, encoding: NSUTF8StringEncoding) as String
        defaultWorkouts = Mapper<Workout>().mapArray(defaultWorkoutsJSON)
    }
}

extension WorkoutsProvider {
    
    func addUserWorkout(workout: Workout) {
        userWorkouts.append(workout)
        notifyObserversDidUpdateUserWorkouts()
        commitChanges()
    }
    
    func removeUserWorkout(workout: Workout) {
        if let index = userWorkouts.indexOf(workout) {
            removeUserWorkoutAtIndex(index)
        }
    }
    
    func removeUserWorkoutAtIndex(index: Int) {
        userWorkouts.removeAtIndex(index)
        notifyObserversDidUpdateUserWorkouts()
        commitChanges()
    }
    
    func moveUserWorkoutFromIndex(fromIndex: Int, toIndex: Int) {
        let workoutToMove = userWorkouts[fromIndex]
        userWorkouts.removeAtIndex(fromIndex)
        userWorkouts.insert(workoutToMove, atIndex: toIndex)
        notifyObserversDidUpdateUserWorkouts()
        commitChanges()
    }
    
    func updateUserWorkout(workout: Workout, withWorkout newWorkout: Workout) {
        for (index, aWorkout) in userWorkouts.enumerate() {
            if aWorkout.identifier == workout.identifier {
                userWorkouts[index] = newWorkout
                notifyObserversDidUpdateUserWorkouts()
                commitChanges()
                break
            }
        }
    }
    
    func insertUserWorkout(workout: Workout, atIndex index: Int) {
        userWorkouts.insert(workout, atIndex: index)
        notifyObserversDidUpdateUserWorkouts()
        commitChanges()
    }
    
    func userWorkoutWithIdentifier(identifier: String) -> Workout? {
        var resultWorkout: Workout? = nil
        for workout in userWorkouts {
            if workout.identifier == identifier {
                resultWorkout = workout
                break
            }
        }
        
        return resultWorkout
    }
    
    func userWorkoutWithOriginalIdentifier(originalIdentifier: String) -> Workout? {
        var resultWorkout: Workout? = nil
        for workout in userWorkouts {
            if workout.originalIdentifier == originalIdentifier {
                resultWorkout = workout
                break
            }
        }
        
        return resultWorkout
    }
    
    func userWorkoutForWorkout(workout: Workout) -> Workout? {
        if let userWorkout = userWorkoutWithIdentifier(workout.identifier) {
            return userWorkout
        }
        
        if let userWorkout = userWorkoutWithOriginalIdentifier(workout.identifier) {
            return userWorkout
        }
        
        return nil
    }
}

extension WorkoutsProvider {
    
    func searchStepsWithRequest(request: StepsSearchRequest) -> [Step] {
        var workouts = [Workout]()
        workouts.appendContentsOf(userWorkouts)
        workouts.appendContentsOf(defaultWorkouts)
        
        var searchResults = [Step]()
        for workout in workouts {
            for step in workout.steps {
                guard request.searchText == "" || step.name.containsString(request.searchText) else { continue }
                searchResults.append(step)
            }
        }
        return searchResults
    }
    
    func searchWorkoutsWithRequest(request: WorkoutsSearchRequest) -> [Workout] {
        var workouts = [Workout]()
        
        switch request.group {
        case .UserWorkouts:
            workouts.appendContentsOf(userWorkouts)
        case .DefaultWorkouts:
            workouts.appendContentsOf(defaultWorkouts)
        case .AllWorkouts:
            workouts.appendContentsOf(userWorkouts)
            workouts.appendContentsOf(defaultWorkouts)
        }
        
        var searchResults = [Workout]()
        for workout in workouts {
            guard request.searchText == "" ||
                workout.name.containsString(request.searchText) else { continue }
            searchResults.append(workout)
        }
        return searchResults
    }
    
    private func commitChanges() {
        NSKeyedArchiver.archiveRootObject(userWorkouts, toFile: userWorkoutsFilePath)
    }
}

extension WorkoutsProvider {
    
    private func notifyObserversDidUpdateUserWorkouts() {
        for observer in observers {
            observer.workoutsProvider(self, didUpdateUserWorkouts: userWorkouts)
        }
    }
}
