//
//  WelcomePageContentController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/3/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WelcomePageContentController: UIViewController {
    
    @IBOutlet private(set) weak var iconView: UIImageView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var subtitleLabel: UILabel!
    @IBOutlet private weak var contentTopSpace: NSLayoutConstraint!

    var item: WelcomePageItem! {
        didSet {
            guard isViewLoaded() else { return }
            fillWithItem(item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        fillWithItem(item)
    }
}

extension WelcomePageContentController {
    
    private func fillWithItem(item: WelcomePageItem) {
        iconView.image = item.icon
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
    
    private func configureLayout() {
        let sizeType = UIScreen.mainScreen().sizeType
        if sizeType == .iPhone4 {
            contentTopSpace.constant = 64.0
        } else if sizeType == .iPhone5 {
            contentTopSpace.constant = 96.0
        } else if sizeType == .iPhone6 {
            contentTopSpace.constant = 128.0
        } else if sizeType == .iPhone6Plus {
            contentTopSpace.constant = 160.0
        }
    }
}
