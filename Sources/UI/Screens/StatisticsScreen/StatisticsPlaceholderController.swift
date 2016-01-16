//
//  StatisticsPlaceholderController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/15/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class StatisticsPlaceholderController: PlaceholderController {
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }

    @IBAction private func workoutsButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutsScreenFromMainScreenWithSourceType(.UserWorkouts, animated: true)
    }
}
