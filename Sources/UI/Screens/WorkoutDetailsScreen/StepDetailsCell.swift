//
//  StepDetailsCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/28/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class StepDetailsCell: ActionableCollectionViewCell {

    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    @IBOutlet private(set) weak var indexLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionVisualizationEnabled = false
        actionsEnabled = false
    }
    
    func fillWithItem(item: StepDetailsCellItem) {
        nameLabel.text = item.step.name
        descriptionLabel.text = item.step.muscleGroupsDescription
        indexLabel.text = String(item.index)
    }
}
