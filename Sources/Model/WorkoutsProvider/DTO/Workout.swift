//
//  Workout.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import Foundation

class Workout: NSObject, NSCoding {
    
    let name: String
    let workoutDescription: String
    let steps: [Step]
    let id: String
    
    required init(name: String, description:String, steps: [Step]) {
        self.name = name
        self.workoutDescription = description
        self.steps = steps
        self.id = NSUUID().UUIDString
        super.init()
    }
    
    required init(name: String, description: String, steps: [Step], id: String) {
        self.name = name
        self.workoutDescription = description
        self.steps = steps
        self.id = id
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        workoutDescription = aDecoder.decodeObjectForKey("description") as! String
        steps = aDecoder.decodeObjectForKey("steps") as! [Step]
        id = aDecoder.decodeObjectForKey("id") as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(workoutDescription, forKey: "description")
        aCoder.encodeObject(steps, forKey: "steps")
        aCoder.encodeObject(id, forKey: "id")
    }
    
    /**
     Creates new Workout instance with identical fields values,
     but with new identifier.
     
     - returns: New instance of Workout.
     */
    func clone() -> Self {
        return self.dynamicType.init(name: name, description: description, steps: steps)
    }
}

extension Workout {
    
    func workoutBySettingName(name: String) -> Self {
        return self.dynamicType.init(name: name, description: workoutDescription, steps: steps, id: id)
    }
    
    func workoutBySettingDescription(description: String) -> Self {
        return self.dynamicType.init(name: name, description: workoutDescription, steps: steps, id: id)
    }
    
    func workoutByAddingStep(step: Step) -> Self {
        var newSteps = steps
        newSteps.append(step)
        
        return self.dynamicType.init(name: name, description: workoutDescription, steps: newSteps, id: id)
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
        
        return self.dynamicType.init(name: name, description: workoutDescription, steps: newSteps, id: id)
    }
    
    func workoutByReplacingStepAtIndex(index: Int, withStep newStep: Step) -> Self {
        var newSteps = steps
        newSteps[index] = newStep
        
        return self.dynamicType.init(name: name, description: workoutDescription, steps: newSteps, id: id)
    }
    
    func workoutByMovingStepFromIndex(fromIndex: Int, toIndex: Int) -> Self {
        let stepToMove = steps[fromIndex]
        var newSteps = steps
        newSteps.removeAtIndex(fromIndex)
        newSteps.insert(stepToMove, atIndex: toIndex)

        return self.dynamicType.init(name: name, description: workoutDescription, steps: newSteps, id: id)
    }
}

extension Workout {
    
    class func emptyWorkout() -> Self {
        return self.init(name: "", description: "", steps: [])
    }
    
    func isEmpty() -> Bool {
        return name == "" &&
            workoutDescription == "" &&
            steps.count == 0
    }
}