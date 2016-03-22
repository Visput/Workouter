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
        configureBarButtonItems()
    }
}

extension BaseScreen {
    
    func setWhiteBackgroundForNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "background_white"),
            forBarMetrics: .Default)
    }
    
    func setTransparentBackgroundForNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
            forBarMetrics: .Default)
    }
}

extension BaseScreen {
    
    func backButtonShown() -> Bool {
        return navigationController?.viewControllers.count > 1
    }
    
    func backButtonDidPress(sender: AnyObject) {
        navigationManager.popScreenAnimated(true)
    }
    
    func configureBarButtonItems() {
        // Hide standard back button as we use custom buttons.
        navigationItem.hidesBackButton = true
        
        if backButtonShown() {
            navigationItem.leftBarButtonItem = UIBarButtonItem.greenBackItemWithAlignment(.Left,
                target: self,
                action: #selector(BaseScreen.backButtonDidPress(_:)))
        }
    }
}
