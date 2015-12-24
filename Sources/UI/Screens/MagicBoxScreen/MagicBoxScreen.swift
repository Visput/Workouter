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
            UIImage(named: "icon_timer_green")!
        ]
    }()
    
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
}
