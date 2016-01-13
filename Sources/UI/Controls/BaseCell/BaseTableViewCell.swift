//
//  BaseTableViewCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/5/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setSemiTransparent(selected, animated: animated)
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        setSemiTransparent(highlighted, animated: animated)
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
