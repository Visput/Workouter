//
//  StatisticsProvider.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/13/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class StatisticsProvider: NSObject {

    var mostFrequentlyPlayedWorkout: Workout? {
        var workout: Workout? = nil
        if workoutsProvider.workouts.count > 0 {
            workout = workoutsProvider.workouts[0]
        }
        return workout
    }
    
    let observers = ObserverSet<StatisticsProviderObserving>()
    
    private let workoutsProvider: WorkoutsProvider
    
    required init(workoutsProvider: WorkoutsProvider) {
        self.workoutsProvider = workoutsProvider
        super.init()
        
        self.workoutsProvider.observers.addObserver(self)
    }
}

extension StatisticsProvider: WorkoutsProviderObserving {
    
    func workoutsProvider(provider: WorkoutsProvider, didUpdateWorkouts workouts: [Workout]) {
        notifyObserversDidUpdateMostFrequentlyPlayedWorkout(mostFrequentlyPlayedWorkout)
    }
}

extension StatisticsProvider {
    
    private func notifyObserversDidUpdateMostFrequentlyPlayedWorkout(workout: Workout?) {
        for observer in observers {
            observer.statisticsProvider(self, didUpdateMostFrequentlyPlayedWorkout: workout)
        }
    }
}
