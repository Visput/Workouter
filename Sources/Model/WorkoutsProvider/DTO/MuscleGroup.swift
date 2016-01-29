//
//  MuscleGroup.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/28/16.
//  Copyright © 2016 visput. All rights reserved.
//

import Foundation

enum MuscleGroup: String {
    // Front side.
    case Shoulders = "Shoulders"
    case Chest = "Chest"
    case Biceps = "Biceps"
    case Forearms = "Forearms"
    case Abs = "Abs"
    case Obliques = "Obliques"
    case Quads = "Quads"
    case Abductors = "Abductors"
    case Adductors = "Adductors"
    
    // Back side.
    case Traps = "Traps"
    case Lats = "Lats"
    case Triceps = "Triceps"
    case LowerBack = "Lower back"
    case Glutes = "Glutes"
    case Hamstrings = "Hamstrings"
    case Calves = "Calves"
    
    func localizedName() -> String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
