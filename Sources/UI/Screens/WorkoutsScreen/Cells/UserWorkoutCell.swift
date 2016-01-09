//
//  UserWorkoutCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/5/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class UserWorkoutCell: BaseCollectionViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var stepsCountLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private(set) weak var cardView: UIView!
    @IBOutlet private(set) weak var scrollView: UIScrollView!
    
    private(set) var workout: Workout?
    
    func fillWithWorkout(workout: Workout) {
        self.workout = workout
        
        nameLabel.text = workout.name
        descriptionLabel.text = workout.workoutDescription
        
        withVaList([workout.steps.count]) { pointer in
            stepsCountLabel.vp_setAttributedTextFormatArguments(pointer, keepFormat: true)
        }
        
        durationLabel.attributedText = NSAttributedString.durationStringForWorkout(workout,
            valueFont: UIFont.systemFontOfSize(14.0, weight: UIFontWeightRegular),
            unitFont: UIFont.systemFontOfSize(12.0, weight: UIFontWeightRegular),
            color: UIColor.secondaryTextColor())
    }
}

extension UserWorkoutCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Allow scrolling only in left direction.
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.y = 0
        } else {
            scrollView.contentOffset.x = 0
            scrollView.contentOffset.y = 0
        }
        
        // Shift scroll view frame to leave action buttons expanded.
        if scrollView.contentOffset.x >= 210.0 {
            scrollView.frame.origin.x = -210.0
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            
            // Shift scroll view frame to expand action buttons.
            if scrollView.contentOffset.x >= 70.0 {
                UIView.animateWithDuration(1.0,
                    delay: 0.0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 2.0,
                    options: [.CurveEaseIn],
                    animations: {
                        scrollView.frame.origin.x = -210.0
                    }, completion: nil)
                
            }
    }
}
