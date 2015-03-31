//
//  WorkoutPlayer.swift
//  Workouter
//
//  Created by Vladimir Popko on 1/21/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit

class WorkoutPlayer: NSObject {
    
    private(set) var workout: Workout?
   
    func start(#workout: Workout) {
        self.workout = workout
    }
    
    func stop() {
        workout = nil
    }
}
