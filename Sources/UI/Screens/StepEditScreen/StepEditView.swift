//
//  StepEditView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/22/15.
//  Copyright © 2015 visput. All rights reserved.
//

import Foundation
import UIKit

class StepEditView: BaseView {

    override func willDisappear(animated: Bool) {
        endEditing(true)
        super.willDisappear(animated)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        endEditing(true)
    }
}
