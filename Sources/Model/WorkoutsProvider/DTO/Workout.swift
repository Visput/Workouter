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
    
    init(name: String, description:String, steps: [Step]) {
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
    func workoutBySettingName(name: String) -> Workout {
        return Workout(name: name, description: workoutDescription, steps: steps)
    }
    
    func workoutBySettingDescription(description: String) -> Workout {
        return Workout(name: name, description: workoutDescription, steps: steps)
    }
    
    func workoutByAddingStep(step: Step) -> Workout {
        var newSteps = steps
        newSteps.append(step);
        
        return Workout(name: name, description: workoutDescription, steps: newSteps);
    }
    
    func workoutByRemovingStep(step: Step) -> Workout {
        var workout: Workout? = nil
        
        if let index = steps.indexOf(step) {
            workout = workoutByRemovingStepAtIndex(index)
        } else {
            workout = self
        }
        
        return workout!
    }
    
    func workoutByRemovingStepAtIndex(index: Int) -> Workout {
        var newSteps = steps
        newSteps.removeAtIndex(index)
        
        return Workout(name: name, description: workoutDescription, steps: newSteps);
    }
    
    func workoutByReplacingStepAtIndex(index: Int, withStep newStep: Step) -> Workout {
        var workout: Workout? = nil
        
        var newSteps = steps
        if index < steps.count {
            newSteps[index] = newStep
        } else {
            workout = self
        }
    
        return workout!
    }
    
    func workoutByMovingStepFromIndex(fromIndex: Int, toIndex: Int) -> Workout {
        let stepToMove = steps[fromIndex]
        var newSteps = steps
        newSteps.removeAtIndex(fromIndex)
        newSteps.insert(stepToMove, atIndex: toIndex)

        return Workout(name: name, description: workoutDescription, steps: newSteps);
    }
}

extension Workout {
    class func emptyWorkout() -> Workout {
        return Workout(name: "", description: "", steps: [])
    }
    
    func isValid() -> Bool {
        // Description is optional.
        return name != "" && steps.count != 0
    }
}