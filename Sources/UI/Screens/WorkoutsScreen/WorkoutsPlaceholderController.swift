//
//  WorkoutsPlaceholderController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/21/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class WorkoutsPlaceholderController: PlaceholderController {

    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    @IBAction private func workoutsButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutsScreenFromMainScreenWithSourceType(.UserWorkouts, animated: true)
    }
}
