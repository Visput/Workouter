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
        // PlaceholderController is embedded controller.
        // Use superview (container view) to manipulate visibility.
        get {
            return view.superview!.alpha == 1.0
        }
        set {
            view.superview!.alpha = newValue ? 1.0 : 0.0
        }
    }
    
    func setVisible(visible: Bool, animated: Bool) {
        if animated {
            UIView.animateWithDefaultDuration({ _ in
                self.visible = visible
            })
        } else {
            self.visible = visible
        }
    }
}
