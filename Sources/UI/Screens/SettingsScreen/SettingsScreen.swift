//
//  SettingsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class SettingsScreen: BaseScreen {
    
    var didCancelAction: (() -> Void)?
    
    private var settingsItems: [SettingsItem]!
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSettingsItems()
    }
}

extension SettingsScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SettingsCell.className(),
            forIndexPath: indexPath) as! SettingsCell
        let item = settingsItems[indexPath.item]
        cell.fillWithItem(item)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let item = settingsItems[indexPath.item]
        item.action()
    }
}

extension SettingsScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.leftBarButtonItem = UIBarButtonItem.greenCancelItemWithAlignment(.Left,
            target: self,
            action: Selector("cancelButtonDidPress:"))
    }
    
    @objc private func cancelButtonDidPress(sender: AnyObject) {
        didCancelAction?()
    }
}

extension SettingsScreen {
    
    private func configureSettingsItems() {
        settingsItems = [SettingsItem]()
        
        settingsItems.append(SettingsItem(title: NSLocalizedString("Refer Friends", comment: ""),
            icon: UIImage(named: "icon_info_green")!,
            action: { [unowned self] in
                self.navigationManager.pushReferFriendsScreenAnimated(true)
            }))
        
        settingsItems.append(SettingsItem(title: NSLocalizedString("Review App", comment: ""),
            icon: UIImage(named: "icon_info_green")!,
            action: { [unowned self] in
                self.navigationManager.pushReferFriendsScreenAnimated(true)
            }))
        
        settingsItems.append(SettingsItem(title: NSLocalizedString("Contact Support", comment: ""),
            icon: UIImage(named: "icon_info_green")!,
            action: { [unowned self] in
                self.navigationManager.pushReferFriendsScreenAnimated(true)
            }))
    }
}
