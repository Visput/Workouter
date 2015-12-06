//
//  BaseScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

class BaseScreen: BaseViewController {
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureBackButton()
    }
}

extension BaseScreen {
    
    func backButtonDidPress(sender: AnyObject) {
        navigationManager.popScreenAnimated(true)
    }
    
    private func configureBackButton() {
        navigationItem.hidesBackButton = true
        
        if navigationController?.viewControllers.count > 1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem.backItemWithTarget(self,
                action: Selector("backButtonDidPress:"))
        }
    }
}
