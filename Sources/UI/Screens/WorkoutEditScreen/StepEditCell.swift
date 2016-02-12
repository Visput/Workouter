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
    @IBOutlet private(set) weak var reorderButton: UIButton!
    
    var reorderGestureRecognizer: UILongPressGestureRecognizer? {
        willSet {
            guard reorderGestureRecognizer != nil else { return }
            reorderButton.removeGestureRecognizer(reorderGestureRecognizer!)
        }
        
        didSet {
            guard reorderGestureRecognizer != nil else { return }
            reorderButton.addGestureRecognizer(reorderGestureRecognizer!)
        }
    }
    
    override var actionsVisible: Bool {
        didSet {
            if !actionsVisible {
                layer.borderWidth = 0.0
                layer.borderColor = UIColor.clearColor().CGColor
            }
        }
    }
    
    override var indexPath: NSIndexPath! {
        didSet {
            deleteButton.tag = indexPath.item
            cloneButton.tag = indexPath.item
            reorderButton.tag = indexPath.item
        }
    }
    
    private(set) var item: StepEditCellItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Prevent multiple cells interaction.
        deleteButton.exclusiveTouch = true
        cloneButton.exclusiveTouch = true
        reorderButton.exclusiveTouch = true
        scrollView.exclusiveTouch = true
    }
    
    func fillWithItem(item: StepEditCellItem) {
        self.item = item
        
        expandingEnabled = true
        actionsEnabled = true
        
        nameLabel.text = item.step.name
        descriptionLabel.text = item.step.muscleGroupsDescription
        indexLabel.text = String(item.index)
    }
    
    func applyReorderingInProgressAppearance() {
        layer.borderWidth = 1.0
        layer.borderColor = reorderButton.backgroundColor!.CGColor
        setActionsOverlayOffset(reorderButton.bounds.size.width)
    }
}
