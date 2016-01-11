//
//  Workout.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import Foundation
import ObjectMapper

final class Workout: NSObject, NSCoding, Mappable {
    
    let nameMaxLength = 70
    let descriptionMaxLength = 140
    
    private(set) var name: String = ""
    private(set) var workoutDescription: String = ""
    private(set) var steps: [Step] = []
    private(set) var identifier: String = ""
    
    /// Identifier of original workout which was cloned to create this workout.
    private(set) var originalIdentifier: String?
    
    init(name: String, description: String, steps: [Step]) {
        self.name = name
        self.workoutDescription = description
        self.steps = steps
        self.identifier = NSUUID().UUIDString
        super.init()
    }
    
    private init(name: String, description: String, steps: [Step], identifier: String) {
        self.name = name
        self.workoutDescription = description
        self.steps = steps
        self.identifier = identifier
        super.init()
    }
    
    private init(name: String, description: String, steps: [Step], originalIdentifier: String?) {
        self.name = name
        self.workoutDescription = description
        self.steps = steps
        self.originalIdentifier = originalIdentifier
        self.identifier = NSUUID().UUIDString
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        workoutDescription = aDecoder.decodeObjectForKey("workoutDescription") as! String
        steps = aDecoder.decodeObjectForKey("steps") as! [Step]
        identifier = aDecoder.decodeObjectForKey("identifier") as! String
        originalIdentifier = aDecoder.decodeObjectForKey("originalIdentifier") as? String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(workoutDescription, forKey: "workoutDescription")
        aCoder.encodeObject(steps, forKey: "steps")
        aCoder.encodeObject(identifier, forKey: "identifier")
        aCoder.encodeObject(originalIdentifier, forKey: "originalIdentifier")
    }
    
    init?(_ map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        workoutDescription <- map["description"]
        steps <- map["steps"]
        identifier <- map["identifier"]
        originalIdentifier <- map["originalIdentifier"]
    }
    
    /**
     Creates new Workout instance with identical fields values,
     but with new identifier.
     Workout `identifier` is set as `originalIdentifier` for cloned workout.
     
     - returns: New instance of Workout.
     */
    func clone() -> Self {
        return self.dynamicType.init(name: name, description: workoutDescription, steps: steps, originalIdentifier: identifier)
    }
}

extension Workout {
    
    func workoutBySettingName(name: String) -> Self {
        return self.dynamicType.init(name: name, description: workoutDescription, steps: steps, identifier: identifier)
    }
    
    func workoutBySettingDescription(description: String) -> Self {
        return self.dynamicType.init(name: name, description: description, steps: steps, identifier: identifier)
    }
    
    func workoutByAddingStep(step: Step) -> Self {
        var newSteps = steps
        newSteps.append(step)
        
        return self.dynamicType.init(name: name, description: workoutDescription, steps: newSteps, identifier: identifier)
    }
    
    func workoutByRemovingStep(step: Step) -> Self {
        var workout = self
        
        if let index = steps.indexOf(step) {
            workout = workoutByRemovingStepAtIndex(index)
        }
        
        return workout
    }
    
    func workoutByRemovingStepAtIndex(index: Int) -> Self {
        var newSteps = steps
        newSteps.removeAtIndex(index)
        
        return self.dynamicType.init(name: name, description: workoutDescription, steps: newSteps, identifier: identifier)
    }
    
    func workoutByReplacingStepAtIndex(index: Int, withStep newStep: Step) -> Self {
        var newSteps = steps
        newSteps[index] = newStep
        
        return self.dynamicType.init(name: name, description: workoutDescription, steps: newSteps, identifier: identifier)
    }
    
    func workoutByMovingStepFromIndex(fromIndex: Int, toIndex: Int) -> Self {
        let stepToMove = steps[fromIndex]
        var newSteps = steps
        newSteps.removeAtIndex(fromIndex)
        newSteps.insert(stepToMove, atIndex: toIndex)
        
        return self.dynamicType.init(name: name, description: workoutDescription, steps: newSteps, identifier: identifier)
    }
}

extension Workout {
    
    class func emptyWorkout() -> Self {
        return self.init(name: "", description: "", steps: [])
    }
}
