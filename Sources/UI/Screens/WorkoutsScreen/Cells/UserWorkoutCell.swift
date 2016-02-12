//
//  UserWorkoutCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/5/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class UserWorkoutCell: ActionableCollectionViewCell {
    
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    @IBOutlet private(set) weak var stepsCountLabel: UILabel!
    @IBOutlet private(set) weak var durationLabel: UILabel!
    
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
    
    private(set) var item: UserWorkoutCellItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Prevent multiple cells interaction.
        deleteButton.exclusiveTouch = true
        cloneButton.exclusiveTouch = true
        reorderButton.exclusiveTouch = true
        scrollView.exclusiveTouch = true
    }
    
    func fillWithItem(item: UserWorkoutCellItem) {
        self.item = item
        
        expandingEnabled = false
        actionsEnabled = item.actionsEnabled
        
        nameLabel.text = item.workout.name
        descriptionLabel.text = item.workout.muscleGroupsDescription
        
        withVaList([item.workout.steps.count]) { pointer in
            stepsCountLabel.vp_setAttributedTextFormatArguments(pointer, keepFormat: true)
        }
        
        durationLabel.attributedText = NSAttributedString.durationStringForWorkout(item.workout,
            valueFont: UIFont.systemFontOfSize(14.0, weight: UIFontWeightRegular),
            unitFont: UIFont.systemFontOfSize(12.0, weight: UIFontWeightRegular),
            color: UIColor.secondaryTextColor())
    }
    
    func applyReorderingInProgressAppearance() {
        layer.borderWidth = 1.0
        layer.borderColor = reorderButton.backgroundColor!.CGColor
        setActionsOverlayOffset(reorderButton.bounds.size.width)
    }
}
