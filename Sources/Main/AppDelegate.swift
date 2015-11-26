//
//  AppDelegate.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/25/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import TwitterKit
import Parse
import FBSDKCoreKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var modelProvider: ModelProvider!
    
    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            AppAppearance.applyAppearance()
            
            // Initiate third-party frameworks.
            AnalyticsTracker.startSession()
            Fabric.with([Crashlytics(), Twitter()])
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
            Parse.enableLocalDatastore()
            Parse.setApplicationId(NSBundle.mainBundle().objectForInfoDictionaryKey("ParseAppID") as! String,
                clientKey:NSBundle.mainBundle().objectForInfoDictionaryKey("ParseClientID") as! String)
            
            // Initiate model.
            modelProvider = ModelProvider.provider
            modelProvider.navigationManager.window = window!
            modelProvider.workoutsProvider.loadWorkouts()
            modelProvider.shortcutsManager.updateShortcuts()
            
            return !modelProvider.shortcutsManager.handleShortcutInAppLaunchOptions(launchOptions)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        modelProvider.navigationManager.presentAuthenticationScreenAnimated(false)
        modelProvider.shortcutsManager.performActionForLaunchedShortcutIfNeeded()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    func application(application: UIApplication,
        performActionForShortcutItem shortcutItem: UIApplicationShortcutItem,
        completionHandler: Bool -> Void) {
            
            let handled = modelProvider.shortcutsManager.performActionForShortcut(shortcutItem)
            completionHandler(handled)
    }
}
