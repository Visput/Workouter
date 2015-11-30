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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return keyboardPresented ? .Default : .LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "UserNickname" {
            nicknameController = segue.destinationViewController as! TextFieldController
            configureNicknameController()
        }
    }
}

extension AuthenticationScreen {
    
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification)
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension AuthenticationScreen {
    
    @IBAction private func signInWithFacebookButtonDidPress(sender: AnyObject) {
        authenticationView.endEditing(true)
        navigationManager.dismissScreenAnimated(true)
    }
    
    @IBAction private func signInWithNicknameButtonDidPress(sender: AnyObject) {
        authenticationView.endEditing(true)
        if validateUserData() {
            navigationManager.dismissScreenAnimated(true)
        }
    }
}

extension AuthenticationScreen {
    
    private func configureNicknameController() {
        nicknameController.placeholder = NSLocalizedString("Nickname", comment: "")
        nicknameController.descriptionTitle = NSLocalizedString("Nickname", comment: "")
        nicknameController.descriptionMessage = NSLocalizedString("Your short name best known by friends and family.", comment: "")
        nicknameController.didChangeTextAction = { [unowned self] text in
            self.nicknameController.setValid()
        }
    }
    
    private func validateUserData() -> Bool {
        if nicknameController.text.isEmpty {
            nicknameController.setInvalidWithErrorTitle("Error", errorMessage: "Nickname is required field.")
        } else {
            nicknameController.setValid()
        }
        
        return nicknameController.valid
    }
}
