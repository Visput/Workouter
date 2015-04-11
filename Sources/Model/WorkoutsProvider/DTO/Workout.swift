//
//  Workout.swift
//  Workouter
//
//  Created by Vladimir Popko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit

class Workout: NSObject, NSCoding {
    
    private(set) var name: String!
    private(set) var steps: [WorkoutStep]!
    
    init(name: String, steps: [WorkoutStep]) {
        self.name = name
        self.steps = steps
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        steps = aDecoder.decodeObjectForKey("steps") as! [WorkoutStep]
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(steps, forKey: "steps")
    }
}
