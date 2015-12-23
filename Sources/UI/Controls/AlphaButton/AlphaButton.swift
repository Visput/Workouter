//
//  AlphaButton.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/23/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class AlphaButton: UIButton {

    override var enabled: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override var selected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override var highlighted: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateAppearance()
    }
    
    func updateAppearance() {
        guard enabled else {
            fatalError("Disabled state is deprecated for better user experience.")
        }
        
        adjustsImageWhenHighlighted = false
        setTitleColor(titleColorForState(.Normal), forState: .Highlighted)
        setTitleColor(titleColorForState(.Normal)?.selectedColor(), forState: .Selected)
        
        alpha = highlighted ? 0.4 : 1.0
    }
}
