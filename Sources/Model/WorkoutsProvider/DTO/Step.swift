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
    
    let nameMaxLength = 70
    
    private(set) var name: String = ""
    private(set) var muscleGroups: [MuscleGroup] = []
    private(set) var rest: Int = 0 // Seconds.
    private(set) var durationGoal: Int? // Seconds.
    private(set) var distanceGoal: Int? // Meters.
    private(set) var weightGoal: Int? // Grams.
    private(set) var repsGoal: Int? // Number of reps.
    
    var muscleGroupsDescription: String {
        var description = ""
        for muscleGroup in muscleGroups {
            if description.characters.count != 0 {
                description.appendContentsOf(", ")
            }
            description.appendContentsOf(muscleGroup.localizedName())
        }
        return description
    }
    
    required init(name: String,
        muscleGroups: [MuscleGroup],
        rest: Int,
        durationGoal: Int?,
        distanceGoal: Int?,
        weightGoal: Int?,
        repsGoal: Int?) {
            
        self.name = name
        self.muscleGroups = muscleGroups
        self.rest = rest
        self.durationGoal = durationGoal
        self.distanceGoal = distanceGoal
        self.weightGoal = weightGoal
        self.repsGoal = repsGoal
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        rest = aDecoder.decodeObjectForKey("rest") as! Int
        durationGoal = aDecoder.decodeObjectForKey("durationGoal") as! Int?
        distanceGoal = aDecoder.decodeObjectForKey("distanceGoal") as! Int?
        weightGoal = aDecoder.decodeObjectForKey("weightGoal") as! Int?
        repsGoal = aDecoder.decodeObjectForKey("repsGoal") as! Int?
        
        let rawValues = aDecoder.decodeObjectForKey("muscleGroups") as! [String]
        var values = [MuscleGroup]()
        for rawValue in rawValues {
            values.append(MuscleGroup(rawValue: rawValue)!)
        }
        muscleGroups = values
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(rest, forKey: "rest")
        aCoder.encodeObject(durationGoal, forKey: "durationGoal")
        aCoder.encodeObject(distanceGoal, forKey: "distanceGoal")
        aCoder.encodeObject(weightGoal, forKey: "weightGoal")
        aCoder.encodeObject(repsGoal, forKey: "repsGoal")
        
        var rawValues = [String]()
        for muscleGroup in muscleGroups {
            rawValues.append(muscleGroup.rawValue)
        }
        aCoder.encodeObject(rawValues, forKey: "muscleGroups")
    }
    
    init?(_ map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        muscleGroups <- map["muscle_groups"]
        rest <- map["rest"]
        durationGoal <- map["duration_goal"]
        distanceGoal <- map["distance_goal"]
        weightGoal <- map["weight_goal"]
        repsGoal <- map["reps_goal"]
    }
}

extension Step {
    
    func stepBySettingName(name: String) -> Self {
        return self.dynamicType.init(name: name,
            muscleGroups: muscleGroups,
            rest: rest,
            durationGoal: durationGoal,
            distanceGoal: distanceGoal,
            weightGoal: weightGoal,
            repsGoal: repsGoal)
    }
    
    func stepBySettingMuscleGroups(muscleGroups: [MuscleGroup]) -> Self {
        return self.dynamicType.init(name: name,
            muscleGroups: muscleGroups,
            rest: rest,
            durationGoal: durationGoal,
            distanceGoal: distanceGoal,
            weightGoal: weightGoal,
            repsGoal: repsGoal)
    }
    
    func stepBySettingRest(rest: Int) -> Self {
        return self.dynamicType.init(name: name,
            muscleGroups: muscleGroups,
            rest: rest,
            durationGoal: durationGoal,
            distanceGoal: distanceGoal,
            weightGoal: weightGoal,
            repsGoal: repsGoal)
    }
    
    func stepBySettingDurationGoal(durationGoal: Int?) -> Self {
        return self.dynamicType.init(name: name,
            muscleGroups: muscleGroups,
            rest: rest,
            durationGoal: durationGoal,
            distanceGoal: distanceGoal,
            weightGoal: weightGoal,
            repsGoal: repsGoal)
    }
    
    func stepBySettingDistanceGoal(distanceGoal: Int?) -> Self {
        return self.dynamicType.init(name: name,
            muscleGroups: muscleGroups,
            rest: rest,
            durationGoal: durationGoal,
            distanceGoal: distanceGoal,
            weightGoal: weightGoal,
            repsGoal: repsGoal)
    }
    
    func stepBySettingWeightGoal(weightGoal: Int?) -> Self {
        return self.dynamicType.init(name: name,
            muscleGroups: muscleGroups,
            rest: rest,
            durationGoal: durationGoal,
            distanceGoal: distanceGoal,
            weightGoal: weightGoal,
            repsGoal: repsGoal)
    }
    
    func stepBySettingRepsGoal(repsGoal: Int?) -> Self {
        return self.dynamicType.init(name: name,
            muscleGroups: muscleGroups,
            rest: rest,
            durationGoal: durationGoal,
            distanceGoal: distanceGoal,
            weightGoal: weightGoal,
            repsGoal: repsGoal)
    }
}

extension Step {
    
    class func emptyStep() -> Self {
        return self.init(name: "",
            muscleGroups: [],
            rest: 0,
            durationGoal: nil,
            distanceGoal: nil,
            weightGoal: nil,
            repsGoal: nil)
    }
    
    func isEmpty() -> Bool {
        return name == "" &&
        muscleGroups == [] &&
        rest == 0 &&
        durationGoal == nil &&
        distanceGoal == nil &&
        weightGoal == nil &&
        repsGoal == nil
    }
}
