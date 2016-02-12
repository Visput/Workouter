//
//  BaseCollectionViewCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/5/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override var selected: Bool {
        didSet {
            setSemiTransparent(selected, animated: true)
        }
    }
    
    override var highlighted: Bool {
        didSet {
            setSemiTransparent(highlighted, animated: true)
        }
    }
    
    private func setSemiTransparent(semiTransparent: Bool, animated: Bool) {
        let alpha: CGFloat = semiTransparent ? 0.4 : 1.0
        
        if animated {
            let animationDuration = semiTransparent ? 0.1 : 0.3
            UIView.animateWithDuration(animationDuration, animations: {
                self.alpha = alpha
            })
        } else {
            self.alpha = alpha
        }
    }
}
