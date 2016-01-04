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
    
    /// Set to 'true' if your intent is to search templates for new workout.
    let isTemplates: Bool
    
    let group: WorkoutsGroup
    
    required init(searchText: String, isTemplates: Bool, group: WorkoutsGroup) {
        self.searchText = searchText
        self.isTemplates = isTemplates
        self.group = group
        super.init()
    }
}

extension WorkoutsSearchRequest {
    
    func requestBySettingSearchText(searchText: String) -> Self {
        return self.dynamicType.init(searchText: searchText, isTemplates: isTemplates, group: group)
    }
    
    func requestBySettingTemplatesCondition(isTemplates: Bool) -> Self {
        return self.dynamicType.init(searchText: searchText, isTemplates: isTemplates, group: group)
    }
    
    func requestBySettingGroup(group: WorkoutsGroup) -> Self {
        return self.dynamicType.init(searchText: searchText, isTemplates: isTemplates, group: group)
    }
}
