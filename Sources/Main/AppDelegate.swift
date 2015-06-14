//
//  AppDelegate.swift
//  Workouter
//
//  Created by Vladimir Popko on 12/25/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import TwitterKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Initiate third-party frameworks
        AnalyticsTracker.startSession()
        Fabric.with([Crashlytics(), Twitter()])
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Parse.enableLocalDatastore()
        Parse.setApplicationId(NSBundle.mainBundle().objectForInfoDictionaryKey("ParseAppID") as! String,
                     clientKey:NSBundle.mainBundle().objectForInfoDictionaryKey("ParseClientID") as! String);
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {

    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {

    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

