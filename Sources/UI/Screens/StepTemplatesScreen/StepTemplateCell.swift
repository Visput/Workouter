//
//  StepTemplateCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/3/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class StepTemplateCell: ActionableCollectionViewCell {

    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    
    func fillWithItem(item: StepTemplateCellItem) {
        expandingEnabled = true
        actionsEnabled = false
        
        nameLabel.text = item.step.name
        descriptionLabel.text = item.step.muscleGroupsDescription
    }
}
