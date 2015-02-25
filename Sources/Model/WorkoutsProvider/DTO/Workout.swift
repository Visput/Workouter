//
//  Workout.swift
//  SportTime
//
//  Created by Vladimir Popko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit

class Workout: NSObject, NSCoding {
    private(set) var name: String!
    private(set) var steps: [WorkoutStep]!
    
    init(name: String, steps: [WorkoutStep]) {
        super.init()
        self.name = name
        self.steps = steps
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObjectForKey("name") as String
        self.steps = aDecoder.decodeObjectForKey("steps") as [WorkoutStep]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.steps, forKey: "steps")
    }
}
