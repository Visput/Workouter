//
//  WorkoutPageContentController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/26/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WorkoutPageContentController: BaseViewController, WorkoutPageContentControlling {
    
    @IBOutlet private(set) weak var nameLabel: UILabel!
    
    var item: WorkoutPageItem! {
        didSet {
            guard isViewLoaded() else { return }
            fillWithItem(item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillWithItem(item)
    }

    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
}

extension WorkoutPageContentController {
    
    @IBAction private func actionButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutPlayerScreenWithWorkout(item.workout!, animated: true)
    }
    
    private func fillWithItem(item: WorkoutPageItem) {
        nameLabel.text = item.workout!.name
    }
}
