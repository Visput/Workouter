//
//  WelcomeScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/1/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class WelcomeScreen: BaseScreen {

    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var welcomeView: WelcomeView {
        return view as! WelcomeView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationManager.setNavigationBarHidden(true, animated: animated)
    }
}

extension WelcomeScreen {
    
    @IBAction private func startButtonDidPress(sender: AnyObject) {
        navigationManager.pushAuthenticationScreenAnimated(true)
    }
}
