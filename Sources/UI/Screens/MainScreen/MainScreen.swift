//
//  MainScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/14/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class MainScreen: BaseScreen {
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var statisticsProvider: StatisticsProvider {
        return modelProvider.statisticsProvider
    }
}

extension MainScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.leftBarButtonItem = UIBarButtonItem.greenSettingsItemWithAlignment(.Left,
            target: self,
            action: Selector("settingsButtonDidPress:"))
    }
    
    @objc private func settingsButtonDidPress(sender: AnyObject) {
        navigationManager.presentSettingsScreenAnimated(true,
            didCancelAction: { [unowned self] in
                self.navigationManager.dismissScreenAnimated(true)
            })
    }
    
    @IBAction private func predictedWorkoutButtonDidPress(sender: AnyObject) {
        let predictedWorkout = statisticsProvider.mostFrequentlyPlayedWorkout!
        navigationManager.pushWorkoutDetailsScreenWithWorkout(predictedWorkout, animated: true)
    }
    
    @IBAction private func workoutsButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutsScreenAnimated(true)
    }
    
    @IBAction private func statisticsButtonDidPress(sender: AnyObject) {
        navigationManager.pushStatisticsScreenAnimated(true)
    }
    
    @IBAction private func achievementsButtonDidPress(sender: AnyObject) {
        navigationManager.pushAchievementsScreenAnimated(true)
    }
    
    @IBAction private func gameButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutGameScreenAnimated(true)
    }
}
