//
//  StepDetailsCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/28/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class StepDetailsCell: ActionableCollectionViewCell {

    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    
    override var selected: Bool {
        didSet {
            // Prevent selection visualization.
            alpha = 1.0
        }
    }
    
    override var highlighted: Bool {
        didSet {
            // Prevent highlighting visualization.
            alpha = 1.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        actionsEnabled = false
    }
    
    func fillWithStep(step: Step) {
        nameLabel.text = step.name
        descriptionLabel.text = step.muscleGroupsDescription
    }
}
