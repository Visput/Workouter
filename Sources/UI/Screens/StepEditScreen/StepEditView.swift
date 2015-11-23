//
//  StepEditView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/22/15.
//  Copyright © 2015 visput. All rights reserved.
//

import Foundation
import UIKit

class StepEditView: BaseScreenView {
    
    @IBOutlet private weak var nameViewHeight: NSLayoutConstraint!
    private let nameViewHeightDefaultValue: CGFloat = 60.0
    
    @IBOutlet private weak var nameViewTopSpace: NSLayoutConstraint!
    private let nameViewTopSpaceDefaultValue: CGFloat = 16.0

    override func willDisappear(animated: Bool) {
        endEditing(true)
        super.willDisappear(animated)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        endEditing(true)
    }
}

extension StepEditView {
    
    func setNameViewHidden(hidden: Bool) {
        let heightValue: CGFloat = hidden ? 0.0 : nameViewHeightDefaultValue
        let topSpaceValue: CGFloat = hidden ? 0.0 : nameViewTopSpaceDefaultValue
        
        nameViewHeight.constant = heightValue
        nameViewTopSpace.constant = topSpaceValue
    }
}
