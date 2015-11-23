//
//  StepsSearchRequest.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/5/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class StepsSearchRequest: NSObject {
    
    let workout: Workout
    let searchText: String
    let includeRestSteps: Bool

    required init(workout: Workout, searchText: String, includeRestSteps: Bool) {
        self.workout = workout
        self.searchText = searchText
        self.includeRestSteps = includeRestSteps
        super.init()
    }
}

extension StepsSearchRequest {
    
    func requestBySettingWorkout(workout: Workout) -> Self {
        return self.dynamicType.init(workout: workout, searchText: searchText, includeRestSteps: includeRestSteps)
    }
    
    func requestBySettingSearchText(searchText: String) -> Self {
        return self.dynamicType.init(workout: workout, searchText: searchText, includeRestSteps: includeRestSteps)
    }
    
    func requestByIncludingRestSteps(includeRestSteps: Bool) -> Self {
        return self.dynamicType.init(workout: workout, searchText: searchText, includeRestSteps: includeRestSteps)
    }
}

extension StepsSearchRequest {
    
    class func emptyRequest() -> Self {
        return self.init(workout: Workout.emptyWorkout(), searchText: "", includeRestSteps: false)
    }
}
