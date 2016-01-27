//
//  WorkoutsSearchRequest.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/7/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WorkoutsSearchRequest: NSObject {
    
    let searchText: String
    let group: WorkoutsGroup
    
    required init(searchText: String, group: WorkoutsGroup) {
        self.searchText = searchText
        self.group = group
        super.init()
    }
}

extension WorkoutsSearchRequest {
    
    func requestBySettingSearchText(searchText: String) -> Self {
        return self.dynamicType.init(searchText: searchText, group: group)
    }
    
    func requestBySettingGroup(group: WorkoutsGroup) -> Self {
        return self.dynamicType.init(searchText: searchText, group: group)
    }
}
