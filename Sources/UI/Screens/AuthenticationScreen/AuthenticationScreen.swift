//
//  AuthenticationScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AuthenticationScreen: BaseScreen {
    
    private var nicknameController: TextFieldController!
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var authenticationView: AuthenticationView {
        return view as! AuthenticationView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.setNavigationBarHidden(true, animated: animated)
        nicknameController.active = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "UserNickname" {
            nicknameController = segue.destinationViewController as! TextFieldController
            configureNicknameController()
        }
    }
}

extension AuthenticationScreen {
    
    private func signInWithFacebook() {
        navigationManager.setMainScreenAsRootAnimated(true)
    }
    
    private func signInWithNickname() {
        if validateNickname() {
            navigationManager.setMainScreenAsRootAnimated(true)
        }
    }
}

extension AuthenticationScreen {
    
    @IBAction private func signInWithFacebookButtonDidPress(sender: AnyObject) {
        signInWithFacebook()
    }
}

extension AuthenticationScreen {
    
    private func configureNicknameController() {
        nicknameController.placeholder = NSLocalizedString("Nickname", comment: "")
        nicknameController.descriptionTitle = NSLocalizedString("Nickname", comment: "")
        nicknameController.descriptionMessage = NSLocalizedString("Your short name best known by friends and family.", comment: "")
        nicknameController.returnKeyTypeForDoneAction = .Go
        nicknameController.didChangeTextAction = { [unowned self] text in
            self.nicknameController.setValid()
        }
        nicknameController.didPressDoneAction = { [unowned self] in
            self.nicknameController.active = true
            self.signInWithNickname()
        }
    }
    
    private func validateNickname() -> Bool {
        if nicknameController.text.isEmpty {
            nicknameController.setInvalidWithErrorTitle("Error", errorMessage: "Nickname is required field.")
        } else {
            nicknameController.setValid()
        }
        
        return nicknameController.valid
    }
}
