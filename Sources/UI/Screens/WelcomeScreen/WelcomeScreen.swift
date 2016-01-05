//
//  WelcomeScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/1/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WelcomeScreen: BaseScreen {
    
    private lazy var pageItems: [WelcomePageItem] = {
        let firstPageItem = WelcomePageItem(title: NSLocalizedString("Workouter", comment: ""),
            subtitle: NSLocalizedString("Welcome to new world of health.", comment: ""),
            icon: UIImage(named: "icon_info_green")!,
            index: 0)
        
        let secondPageItem = WelcomePageItem(title: NSLocalizedString("Healthy", comment: ""),
            subtitle: NSLocalizedString("Workouter consistently improves your health.", comment: ""),
            icon: UIImage(named: "icon_info_green")!,
            index: 1)
        
        let thirdPageItem = WelcomePageItem(title: NSLocalizedString("Customizable", comment: ""),
            subtitle: NSLocalizedString("Workouter allows you create personal workouts.", comment: ""),
            icon: UIImage(named: "icon_info_green")!,
            index: 2)
        
        return [firstPageItem, secondPageItem, thirdPageItem]
    }()
    
    private var autoSwipeTimer: NSTimer?
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        restartAutoSwipeTimer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationManager.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        stopAutoSwipeTimer()
        super.viewDidDisappear(animated)
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
        let currentController = pagesController.viewControllers!.last as! WelcomePageContentController
        return currentController.item.index
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            // Restart timer if user manually swiped to different page.
            restartAutoSwipeTimer()
    }
}

extension WelcomeScreen {
    
    @IBAction private func startButtonDidPress(sender: AnyObject) {
        navigationManager.setMainScreenAsRootAnimated(true)
    }
}

extension WelcomeScreen {
    
    private func restartAutoSwipeTimer() {
        stopAutoSwipeTimer()
        autoSwipeTimer = NSTimer.scheduledTimerWithTimeInterval(5.0,
            target: self,
            selector: "swipeToNextPage",
            userInfo: nil,
            repeats: false)
    }
    
    private func stopAutoSwipeTimer() {
        autoSwipeTimer?.invalidate()
        autoSwipeTimer = nil
    }
    
    @objc private func swipeToNextPage() {
        let currentController = pagesController.viewControllers!.last!
        let nextController = pageViewController(pagesController, viewControllerAfterViewController: currentController)
        guard nextController != nil else { return }
        
        pagesController.setViewControllers([nextController!],
            direction: UIPageViewControllerNavigationDirection.Forward,
            animated: true,
            completion: { [weak self] _ in
                
                self?.restartAutoSwipeTimer()
            })
    }
    
    private func configurePagesController() {
        pagesController.delegate = self
        pagesController.dataSource = self
        let firstController = navigationManager.instantiateWelcomePageContentControllerWithItem(pageItems[0])
        pagesController.setViewControllers([firstController], direction: .Forward, animated: true, completion: nil)
    }
}
