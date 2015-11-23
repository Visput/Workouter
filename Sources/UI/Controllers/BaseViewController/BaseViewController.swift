//
//  BaseViewController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/22/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let modelProvider = ModelProvider.provider
    
    var isViewDisplayed: Bool {
        get {
            return isViewLoaded() && view.window != nil
        }
    }
    
    private var baseView: BaseView {
        return view as! BaseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.didLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        baseView.willAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        baseView.didAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        baseView.willDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        baseView.didDisappear(animated)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}
