//
//  AccountCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/30/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AccountCell: UICollectionViewCell {
    
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var iconView: UIImageView!
    
    override var highlighted: Bool {
        didSet {
            alpha = highlighted ? 0.4 : 1.0
        }
    }
    
    func fillWithItem(item: AccountCellItem) {
        titleLabel.text = item.title
        iconView.image = item.icon
    }
}
