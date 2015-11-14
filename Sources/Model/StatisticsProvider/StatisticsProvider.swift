//
//  StatisticsProvider.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/13/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class StatisticsProvider: NSObject {

    let workoutsProvider: WorkoutsProvider
    
    required init(workoutsProvider: WorkoutsProvider) {
        self.workoutsProvider = workoutsProvider
        super.init()
        
        self.workoutsProvider.observers.addObserver(self)
    }
    
    func mostFrequentlyPlayedWorkout() -> Workout? {
        guard workoutsProvider.workouts.count > 0 else { return nil }
        
        return workoutsProvider.workouts[0];
    }
}

extension StatisticsProvider: WorkoutsProviderObserving {
    
    func workoutsProvider(provider: WorkoutsProvider, didUpdateWorkouts workouts: [Workout]) {

    }
}
