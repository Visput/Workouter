//
//  UserWorkoutCellItem.swift
//  Workouter
//
//  Created by Uladzimir Papko on 2/11/16.
//  Copyright © 2016 visput. All rights reserved.
//

import Foundation

struct UserWorkoutCellItem {
    
    let workout: Workout
    let actionsEnabled: Bool
    
    init(workout: Workout, actionsEnabled: Bool) {
        self.workout = workout
        self.actionsEnabled = actionsEnabled
    }
}
