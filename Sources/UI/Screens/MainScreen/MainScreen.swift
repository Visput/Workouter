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
        navigationItem.leftBarButtonItem = UIBarButtonItem.greenAccountSettingsItemWithAlignment(.Left,
            target: self,
            action: Selector("settingsButtonDidPress:"))
    }
    
    @objc private func settingsButtonDidPress(sender: AnyObject) {
        navigationManager.presentSettingsScreenAnimated(true,
            didCancelAction: { [unowned self] in
                self.navigationManager.dismissScreenAnimated(true)
            })
    }
}
