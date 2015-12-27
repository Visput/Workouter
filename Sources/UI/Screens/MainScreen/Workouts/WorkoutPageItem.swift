//
//  WorkoutPageItem.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/26/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

struct WorkoutPageItem {
    
    let workout: Workout?
    let index: Int
    
    var instantiatePageContentController: ((Void) -> WorkoutPageContentControlling)!
    
    init(workout: Workout?, index: Int) {
        self.workout = workout
        self.index = index
    }
}
