//
//  Workout.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/12/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit

class Workout: NSObject, NSCoding {
    
    let name: String
    let workoutDescription: String
    let steps: [Step]
    
    required init(name: String, description:String, steps: [Step]) {
        self.name = name
        self.workoutDescription = description
        self.steps = steps
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        workoutDescription = aDecoder.decodeObjectForKey("description") as! String
        steps = aDecoder.decodeObjectForKey("steps") as! [Step]
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(workoutDescription, forKey: "description")
        aCoder.encodeObject(steps, forKey: "steps")
    }
}

extension Workout {
    func workoutBySettingName(name: String) -> Self {
        return self.dynamicType.init(name: name, description: workoutDescription, steps: steps)
    }
    
    func workoutBySettingDescription(description: String) -> Self {
        return self.dynamicType.init(name: name, description: workoutDescription, steps: steps)
    }
    
    func workoutByAddingStep(step: Step) -> Self {
        var newSteps = steps
        newSteps.append(step);
        
        return self.dynamicType.init(name: name, description: workoutDescription, steps: newSteps);
    }
    
    func workoutByRemovingStep(step: Step) -> Self {
        if let index = steps.indexOf(step) {
            return workoutByRemovingStepAtIndex(index)
        }
        
        return self
    }
    
    func workoutByRemovingStepAtIndex(index: Int) -> Self {
        var newSteps = steps
        newSteps.removeAtIndex(index)
        
        return self.dynamicType.init(name: name, description: workoutDescription, steps: newSteps);
    }
    
    func workoutByReplacingStepAtIndex(index: Int, withStep newStep: Step) -> Self {
        if index < steps.count {
            var newSteps = steps
            newSteps[index] = newStep
            return self.dynamicType.init(name: name, description: workoutDescription, steps: newSteps);
        }
    
        return self
    }
    
    func workoutByMovingStepFromIndex(fromIndex: Int, toIndex: Int) -> Self {
        let stepToMove = steps[fromIndex]
        var newSteps = steps
        newSteps.removeAtIndex(fromIndex)
        newSteps.insert(stepToMove, atIndex: toIndex)

        return self.dynamicType.init(name: name, description: workoutDescription, steps: newSteps);
    }
}

extension Workout {
    class func emptyWorkout() -> Self {
        return self.init(name: "", description: "", steps: [])
    }
    
    func isValid() -> Bool {
        // Description is optional.
        return name != "" && steps.count != 0
    }
}