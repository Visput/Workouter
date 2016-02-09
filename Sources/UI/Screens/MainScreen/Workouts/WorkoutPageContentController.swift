//
//  WorkoutPageContentController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/26/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit
import VPAttributedFormat

final class WorkoutPageContentController: BaseViewController, WorkoutPageContentControlling, UIViewControllerPreviewingDelegate {
    
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    @IBOutlet private(set) weak var durationLabel: UILabel!
    @IBOutlet private(set) weak var stepsCountLabel: UILabel!
    
    var item: WorkoutPageItem! {
        didSet {
            guard isViewLoaded() else { return }
            fillWithItem(item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForPreviewing()
        fillWithItem(item)
    }

    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
}

extension WorkoutPageContentController {
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            
            let previewScreen = navigationManager.instantiateWorkoutDetailsScreenWithWorkout(item.workout!)
            return previewScreen
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        commitViewController viewControllerToCommit: UIViewController) {
            
            navigationManager.pushScreen(viewControllerToCommit, animated: true)
    }
    
    private func registerForPreviewing() {
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
    }
}

extension WorkoutPageContentController {
    
    @IBAction private func actionButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutDetailsScreenWithWorkout(item.workout!, animated: true)
    }
    
    private func fillWithItem(item: WorkoutPageItem) {
        nameLabel.text = item.workout!.name
        descriptionLabel.text = item.workout!.muscleGroupsDescription
        
        withVaList([item.workout!.steps.count]) { pointer in
            stepsCountLabel.vp_setAttributedTextFormatArguments(pointer, keepFormat: true)
        }
        
        durationLabel.attributedText = NSAttributedString.durationStringForWorkout(item.workout!,
            valueFont: UIFont.systemFontOfSize(14.0, weight: UIFontWeightRegular),
            unitFont: UIFont.systemFontOfSize(12.0, weight: UIFontWeightRegular),
            color: UIColor.whiteColor())
    }
}
