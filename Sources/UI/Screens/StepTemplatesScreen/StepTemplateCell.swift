//
//  StepTemplateCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/3/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class StepTemplateCell: ActionableCollectionViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionVisualizationEnabled = false
        actionsEnabled = false
    }
    
    func fillWithStep(step: Step) {
        nameLabel.text = step.name
        descriptionLabel.text = step.muscleGroupsDescription
    }
}
