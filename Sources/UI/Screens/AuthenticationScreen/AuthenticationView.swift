//
//  AuthenticationView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AuthenticationView: BaseScreenView {
    
    @IBOutlet private weak var headerHeight: NSLayoutConstraint!
    
    override func didLoad() {
        super.didLoad()
        
        // Configure header view per device size.
        var ratioMultiplier: CGFloat = 2.66
        if UIScreen.mainScreen().sizeType == .iPhone4 {
            ratioMultiplier = 3.50
        }
        headerHeight.constant = frame.size.width / ratioMultiplier
    }
}
