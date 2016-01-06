//
//  AccountCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/30/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AccountCell: BaseCollectionViewCell {
    
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var iconView: UIImageView!
    
    func fillWithItem(item: AccountCellItem) {
        titleLabel.text = item.title
        iconView.image = item.icon
    }
}
