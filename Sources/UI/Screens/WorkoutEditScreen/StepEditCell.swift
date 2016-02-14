//
//  StepEditCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class StepEditCell: ActionableCollectionViewCell {
    
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    @IBOutlet private(set) weak var indexLabel: UILabel!
    
    @IBOutlet private(set) weak var deleteButton: UIButton!
    @IBOutlet private(set) weak var cloneButton: UIButton!
    @IBOutlet private(set) weak var moveButton: UIButton!
    
    private(set) var item: StepEditCellItem?
    
    func fillWithItem(item: StepEditCellItem) {
        self.item = item
        
        nameLabel.text = item.step.name
        descriptionLabel.text = item.step.muscleGroupsDescription
        indexLabel.text = String(item.index)
    }
}
