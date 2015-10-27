//
//  Step.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit

class Step: NSObject, NSCoding {
    
    private(set) var name: String
    private(set) var stepDescription: String
    private(set) var duration: NSTimeInterval
    
    required init(name: String, description: String, duration: NSTimeInterval) {
        self.name = name
        self.stepDescription = description;
        self.duration = duration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        stepDescription = aDecoder.decodeObjectForKey("description") as! String
        duration = aDecoder.decodeDoubleForKey("duration")
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(stepDescription, forKey: "description")
        aCoder.encodeDouble(duration, forKey: "duration")
    }
}

extension Step {
    func stepBySettingName(name: String) -> Self {
        return self.dynamicType.init(name: name, description: stepDescription, duration: duration)
    }
    
    func stepBySettingDescription(description: String) -> Self {
        return self.dynamicType.init(name: name, description: stepDescription, duration: duration)
    }
    
    func stepBySettingDuration(duration: NSTimeInterval) -> Self {
        return self.dynamicType.init(name: name, description: stepDescription, duration: duration)
    }
}

extension Step {
    class func emptyStep() -> Self {
        return self.init(name: "", description: "", duration: 0)
    }
    
    func isValid() -> Bool {
        // Description is optional.
        return name != "" && duration != 0
    }
}
