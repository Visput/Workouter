//
//  BaseDialogView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/20/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class BaseDialogView: BaseView {    
    
    @IBOutlet private(set) weak var contentView: UIView!
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    }
}
