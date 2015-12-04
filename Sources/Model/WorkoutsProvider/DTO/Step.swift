//
//  Step.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit
import ObjectMapper

final class Step: NSObject, NSCoding, Mappable {
    
    enum Type: Int {
        case Exercise = 0
        case Rest
    }
    
    let nameMaxLength = 70
    let descriptionMaxLength = 140
    
    private(set) var type: Type = .Exercise
    private(set) var name: String = ""
    private(set) var stepDescription: String = ""
    private(set) var duration: Int = 0 // Seconds.
    
    required init(type: Type, name: String, description: String, duration: Int) {
        self.type = type
        self.name = name
        self.stepDescription = description
        self.duration = duration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        type = Type(rawValue: aDecoder.decodeIntegerForKey("type"))!
        name = aDecoder.decodeObjectForKey("name") as! String
        stepDescription = aDecoder.decodeObjectForKey("stepDescription") as! String
        duration = aDecoder.decodeIntegerForKey("duration")
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(type.rawValue, forKey: "type")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(stepDescription, forKey: "stepDescription")
        aCoder.encodeInteger(duration, forKey: "duration")
    }
    
    init?(_ map: Map) {}
    
    func mapping(map: Map) {
        type <- map["type"]
        name <- map["name"]
        stepDescription <- map["description"]
        duration <- map["duration"]
    }
}

extension Step {
    
    func stepBySettingType(type: Type) -> Self {
        return self.dynamicType.init(type: type, name: name, description: stepDescription, duration: duration)
    }
    
    func stepBySettingName(name: String) -> Self {
        return self.dynamicType.init(type: type, name: name, description: stepDescription, duration: duration)
    }
    
    func stepBySettingDescription(description: String) -> Self {
        return self.dynamicType.init(type: type, name: name, description: description, duration: duration)
    }
    
    func stepBySettingDuration(duration: Int) -> Self {
        return self.dynamicType.init(type: type, name: name, description: stepDescription, duration: duration)
    }
}

extension Step {
    
    class func emptyExersizeStep() -> Self {
        return self.init(type: .Exercise, name: "", description: "", duration: 0)
    }
    
    class func emptyRestStep() -> Self {
        return self.init(type: .Rest, name: "", description: "", duration: 0)
    }
}
