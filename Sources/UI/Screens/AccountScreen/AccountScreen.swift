//
//  AccountScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/30/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AccountScreen: BaseScreen {
    
    var didCancelAction: (() -> Void)?
    
    private var accountItems: [AccountCellItem]!
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAccountItems()
    }
}

extension AccountScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AccountCell.className(),
            forIndexPath: indexPath) as! AccountCell
        let item = accountItems[indexPath.item]
        cell.fillWithItem(item)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = accountItems[indexPath.item]
        item.action()
    }
}

extension AccountScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.leftBarButtonItem = UIBarButtonItem.greenCancelItemWithAlignment(.Left,
            target: self,
            action: #selector(AccountScreen.cancelButtonDidPress(_:)))
    }
    
    @objc private func cancelButtonDidPress(sender: AnyObject) {
        didCancelAction?()
    }
}

extension AccountScreen {
    
    private func configureAccountItems() {
        accountItems = [AccountCellItem]()
        
        accountItems.append(AccountCellItem(title: NSLocalizedString("Refer Friends", comment: ""),
            icon: UIImage(named: "icon_refer_friend_green")!,
            action: { [unowned self] in
                self.navigationManager.pushReferFriendsScreenAnimated(true)
            }))
        
        accountItems.append(AccountCellItem(title: NSLocalizedString("Rate App", comment: ""),
            icon: UIImage(named: "icon_rate_app_green")!,
            action: { [unowned self] in
                self.navigationManager.pushReferFriendsScreenAnimated(true)
            }))
        
        accountItems.append(AccountCellItem(title: NSLocalizedString("Contact Support", comment: ""),
            icon: UIImage(named: "icon_contact_support_green")!,
            action: { [unowned self] in
                self.navigationManager.pushReferFriendsScreenAnimated(true)
            }))
        
        accountItems.append(AccountCellItem(title: NSLocalizedString("Settings", comment: ""),
            icon: UIImage(named: "icon_settings_green")!,
            action: { [unowned self] in
                self.navigationManager.pushSettingsScreenAnimated(true)
            }))
    }
}
