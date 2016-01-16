//
//  PlaceholderController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/15/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

class PlaceholderController: BaseViewController {

    var visible: Bool {
        get {
            return !view.hidden
        }
        set {
            view.hidden = !visible
        }
    }
    
    func setVisible(visible: Bool, animated: Bool) {
        if animated {
            if visible && !self.visible {
                self.visible = visible
                view.alpha = 0.0
            }
            UIView.animateWithDefaultDuration({ _ in
                self.view.alpha = visible ? 1.0 : 0.0
                }, completion: { _ in
                    self.visible = visible
            })
        } else {
            self.visible = visible
        }
    }
}
