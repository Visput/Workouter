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
    private var emailController: TextFieldController!
    private var passwordController: TextFieldController!

    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var authenticationView: AuthenticationView {
        return view as! AuthenticationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextControllers()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "UserNickname" {
            nicknameController = segue.destinationViewController as! TextFieldController
            configureNicknameController()
            
        } else if segue.identifier! == "UserEmail" {
            emailController = segue.destinationViewController as! TextFieldController
            configureEmailController()
            
        } else if segue.identifier! == "UserPassword" {
            passwordController = segue.destinationViewController as! TextFieldController
            configurePasswordController()
        }
    }
}

extension AuthenticationScreen {
    
    @IBAction private func signInWithFacebookButtonDidPress(sender: AnyObject) {
        authenticationView.endEditing(true)
        navigationManager.dismissScreenAnimated(true)
    }
    
    @IBAction private func signInWithEmailButtonDidPress(sender: AnyObject) {
        authenticationView.endEditing(true)
        if validateUserData() {
            navigationManager.dismissScreenAnimated(true)
        }
    }
    
    @IBAction private func tryItOutButtonDidPress(sender: AnyObject) {
        authenticationView.endEditing(true)
        navigationManager.dismissScreenAnimated(true)
    }
}

extension AuthenticationScreen {
    
    private func configureTextControllers() {
        nicknameController.nextTextFieldController = emailController
        emailController.nextTextFieldController = passwordController
    }
    
    private func configureNicknameController() {
        nicknameController.placeholder = NSLocalizedString("Nickname", comment: "")
        nicknameController.descriptionTitle = NSLocalizedString("Nickname", comment: "")
        nicknameController.descriptionMessage = NSLocalizedString("Your short name best known by friends and family.", comment: "")
        nicknameController.didChangeTextAction = { [unowned self] text in
            self.nicknameController.setValid()
        }
    }
    
    private func configureEmailController() {
        emailController.placeholder = NSLocalizedString("Email", comment: "")
        emailController.descriptionTitle = NSLocalizedString("Email", comment: "")
        emailController.descriptionMessage = NSLocalizedString("Your regular email.\nWe use it for your account synchronization.",
            comment: "")
        emailController.keyboardType = .EmailAddress
        emailController.didChangeTextAction = { [unowned self] text in
            self.emailController.setValid()
        }
    }
    
    private func configurePasswordController() {
        passwordController.placeholder = NSLocalizedString("Password", comment: "")
        passwordController.descriptionTitle = NSLocalizedString("Password", comment: "")
        passwordController.descriptionMessage = NSLocalizedString("Any word that you won't forget.", comment: "")
        passwordController.secureTextEntry = true
        passwordController.didChangeTextAction = { [unowned self] text in
            self.passwordController.setValid()
        }
    }
    
    private func validateUserData() -> Bool {
        if nicknameController.text.isEmpty {
            nicknameController.setInvalidWithErrorTitle("Error", errorMessage: "Nickname is required field.")
        } else {
            nicknameController.setValid()
        }
        
        if emailController.text.isEmpty {
            emailController.setInvalidWithErrorTitle("Error", errorMessage: "Email is required field.")
        } else {
            emailController.setValid()
        }
        
        if passwordController.text.isEmpty {
            passwordController.setInvalidWithErrorTitle("Error", errorMessage: "Password is required field.")
        } else {
            passwordController.setValid()
        }
        
        return nicknameController.valid && emailController.valid && passwordController.valid
    }
}
