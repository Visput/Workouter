//
//  StepEditCellItem.swift
//  Workouter
//
//  Created by Uladzimir Papko on 2/8/16.
//  Copyright © 2016 visput. All rights reserved.
//

import Foundation

struct StepEditCellItem {
    
    let step: Step
    let index: Int
    let actionButtonsTag: Int
    
    init(step: Step, index: Int, actionButtonsTag: Int) {
        self.step = step
        self.index = index
        self.actionButtonsTag = actionButtonsTag
    }
}
