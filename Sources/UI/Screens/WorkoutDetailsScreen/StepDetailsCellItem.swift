//
//  StepDetailsCellItem.swift
//  Workouter
//
//  Created by Uladzimir Papko on 2/6/16.
//  Copyright © 2016 visput. All rights reserved.
//

import Foundation

struct StepDetailsCellItem {
    
    let step: Step
    let index: Int
    
    init(step: Step, index: Int) {
        self.step = step
        self.index = index
    }
}
