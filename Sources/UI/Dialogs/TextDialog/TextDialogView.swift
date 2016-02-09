//
//  TextDialogView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/20/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class TextDialogView: BaseDialogView {
    
    @IBOutlet private(set) weak var primaryTextLabel: UILabel!
    @IBOutlet private(set) weak var secondaryTextLabel: UILabel!
    @IBOutlet private(set) weak var iconView: UIImageView!
    @IBOutlet private(set) weak var confirmButton: TintButton!
    @IBOutlet private(set) weak var cancelButton: TintButton!
}
