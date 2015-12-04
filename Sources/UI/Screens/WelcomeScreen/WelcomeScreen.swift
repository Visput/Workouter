//
//  WelcomeScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/1/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class WelcomeScreen: BaseScreen {
    
    private lazy var pageItems: [WelcomePageItem] = {
        let firstPageItem = WelcomePageItem(title: NSLocalizedString("Workouter", comment: ""),
            subtitle: NSLocalizedString("Welcome to new world of health.", comment: ""),
            icon: UIImage(named: "icon_info")!,
            index: 0)
        
        let secondPageItem = WelcomePageItem(title: NSLocalizedString("Healthy", comment: ""),
            subtitle: NSLocalizedString("Workouter consistently improves your health.", comment: ""),
            icon: UIImage(named: "icon_info")!,
            index: 1)
        
        let thirdPageItem = WelcomePageItem(title: NSLocalizedString("Customizable", comment: ""),
            subtitle: NSLocalizedString("Workouter allows you create personal workouts.", comment: ""),
            icon: UIImage(named: "icon_info")!,
            index: 2)
        
        return [firstPageItem, secondPageItem, thirdPageItem]
    }()
    
    private var pagesController: UIPageViewController!

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "WelcomePages" {
            pagesController = segue.destinationViewController as! UIPageViewController
            configurePagesController()
        }
    }
}

extension WelcomeScreen: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            
            let currentController = viewController as! WelcomePageContentController
            guard currentController.item.index > 0 else { return nil }
            
            let previousPageItem = pageItems[currentController.item.index - 1]
            let previousController = navigationManager.instantiateWelcomePageContentControllerWithItem(previousPageItem)
            
            return previousController
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            
            let currentController = viewController as! WelcomePageContentController
            guard currentController.item.index < pageItems.count - 1 else { return nil }
            
            let nextPageItem = pageItems[currentController.item.index + 1]
            let nextController = navigationManager.instantiateWelcomePageContentControllerWithItem(nextPageItem)
            
            return nextController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageItems.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension WelcomeScreen {
    
    @IBAction private func startButtonDidPress(sender: AnyObject) {
        navigationManager.pushAuthenticationScreenAnimated(true)
    }
}

extension WelcomeScreen {
    
    private func configurePagesController() {
        pagesController.delegate = self
        pagesController.dataSource = self
        let firstController = navigationManager.instantiateWelcomePageContentControllerWithItem(pageItems[0])
        pagesController.setViewControllers([firstController], direction: .Forward, animated: true, completion: nil)
    }
}
