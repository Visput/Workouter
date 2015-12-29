//
//  AchievementsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/14/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AchievementsScreen: BaseScreen {
    
    private var achievementsProvider: AchievementsProvider {
        return modelProvider.achievementsProvider
    }
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        achievementsProvider.loadAchievements()
    }
}

extension AchievementsScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievementsProvider.achievements.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AchievementCell.className(),
            forIndexPath: indexPath) as! AchievementCell
        let achievement = achievementsProvider.achievements[indexPath.item]
        cell.fillWithAchievement(achievement)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let achievement = achievementsProvider.achievements[indexPath.item]
        navigationManager.presentAchievementDetailsScreenWithAchievement(achievement,
            animated: true,
            didCancelAction: { [unowned self] in
                self.navigationManager.dismissScreenAnimated(true)
        })
    }
}
