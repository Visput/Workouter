//
//  WorkoutsPreviewController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/23/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WorkoutsPreviewController: BaseViewController {

    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    @IBAction private func actionButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutsScreenWithSourceType(.All, animated: true)
    }
}
