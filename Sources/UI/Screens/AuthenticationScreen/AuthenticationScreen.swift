//
//  AuthenticationScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AuthenticationScreen: BaseScreen {

    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var authenticationView: AuthenticationView {
        return view as! AuthenticationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension AuthenticationScreen {
    
    @IBAction private func signInWithFacebookButtonDidPress(sender: AnyObject) {
        authenticationView.endEditing(true)
        navigationManager.dismissScreenAnimated(true)
    }
    
    @IBAction private func signInWithEmailButtonDidPress(sender: AnyObject) {
        authenticationView.endEditing(true)
        navigationManager.dismissScreenAnimated(true)
    }
    
    @IBAction private func tryItOutButtonDidPress(sender: AnyObject) {
        authenticationView.endEditing(true)
        navigationManager.dismissScreenAnimated(true)
    }
}
