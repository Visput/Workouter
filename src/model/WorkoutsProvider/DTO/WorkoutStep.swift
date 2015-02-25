//
//  WorkoutStep.swift
//  SportTime
//
//  Created by Vladimir Popko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit

class WorkoutStep: NSObject {
    private(set) var name: String!
    private(set) var duration: Int! // [Sec]
    
    init(name: String, duration: Int) {
        super.init()
        self.name = name
        self.duration = duration
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObjectForKey("name") as String
        self.duration = aDecoder.decodeIntegerForKey("duration")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeInteger(self.duration, forKey: "duration")
    }
}
