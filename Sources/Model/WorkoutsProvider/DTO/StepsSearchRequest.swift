//
//  StepsSearchRequest.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/5/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class StepsSearchRequest: NSObject {
    
    let workout: Workout
    let muscleGroup: MuscleGroup?
    let searchText: String

    required init(workout: Workout, muscleGroup: MuscleGroup?, searchText: String) {
        self.workout = workout
        self.muscleGroup = muscleGroup
        self.searchText = searchText
        super.init()
    }
}

extension StepsSearchRequest {
    
    func requestBySettingWorkout(workout: Workout) -> Self {
        return self.dynamicType.init(workout: workout, muscleGroup: muscleGroup, searchText: searchText)
    }
    
    func requestBySettingMuscleGroup(muscleGroup: MuscleGroup?) -> Self {
        return self.dynamicType.init(workout: workout, muscleGroup: muscleGroup, searchText: searchText)
    }
    
    func requestBySettingSearchText(searchText: String) -> Self {
        return self.dynamicType.init(workout: workout, muscleGroup: muscleGroup, searchText: searchText)
    }
}
