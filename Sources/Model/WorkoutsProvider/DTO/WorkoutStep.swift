//
//  WorkoutStep.swift
//  Workouter
//
//  Created by Vladimir Popko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit

class WorkoutStep: NSObject, NSCoding {
    
    private(set) var name: String!
    private(set) var duration: Int! // [Sec]
    
    init(name: String, duration: Int) {
        self.name = name
        self.duration = duration
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as String
        duration = aDecoder.decodeIntegerForKey("duration")
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeInteger(duration, forKey: "duration")
    }
}
