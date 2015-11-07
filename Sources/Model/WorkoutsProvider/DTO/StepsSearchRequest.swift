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

    required init(workout: Workout, searchText: String) {
        self.workout = workout
        self.searchText = searchText
        super.init()
    }
}

extension StepsSearchRequest {
    
    func requestBySettingWorkout(workout: Workout) -> Self {
        return self.dynamicType.init(workout: workout, searchText: searchText)
    }
    
    func requestBySettingSearchText(searchText: String) -> Self {
        return self.dynamicType.init(workout: workout, searchText: searchText)
    }
}

extension StepsSearchRequest {
    
    class func emptyRequest() -> Self {
        return self.init(workout: Workout.emptyWorkout(), searchText: "")
    }
    
    func isEmpty() -> Bool {
        return workout.isEmpty() &&
            searchText == ""
    }
}
