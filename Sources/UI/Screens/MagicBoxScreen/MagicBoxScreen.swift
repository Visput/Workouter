//
//  MagicBoxScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/13/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class MagicBoxScreen: BaseScreen {
    
    private lazy var icons = {
        return [
            UIImage(named: "icon_bike_green")!,
            UIImage(named: "icon_kettlebell_filled_green")!,
            UIImage(named: "icon_shoes_filled_green")!,
            UIImage(named: "icon_dumbbell_filled_green")!,
            UIImage(named: "icon_timer_green")!,
            UIImage(named: "icon_fitball_green")!,
            UIImage(named: "icon_bottle_filled_green")!,
            UIImage(named: "icon_mat_green")!,
            UIImage(named: "icon_cocktail_filled_green")!,
            UIImage(named: "icon_jumping_rope_green")!,
            UIImage(named: "icon_goggles_green")!,
            UIImage(named: "icon_roller_filled_green")!,
            UIImage(named: "icon_handgrips_filled_green")!,
            UIImage(named: "icon_bar_filled_green")!
        ]
    }()
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var magicBoxView: MagicBoxView {
        return view as! MagicBoxView
    }
}

extension MagicBoxScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MagicBoxIconCell.className(),
            forIndexPath: indexPath) as! MagicBoxIconCell
        cell.iconView.image = icons[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectSelectedItemsAnimated(true)
    }
}

extension MagicBoxScreen {
    
    @objc private func settingsButtonDidPress(sender: AnyObject) {
        navigationManager.presentMagicBoxSettingsScreenAnimated(true, didCancelAction: { [unowned self] in
            self.navigationManager.dismissScreenAnimated(true)
        })
    }
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.rightBarButtonItem = UIBarButtonItem.greenGameSettingsItemWithAlignment(.Right,
            target: self,
            action: Selector("settingsButtonDidPress:"))
    }
}
