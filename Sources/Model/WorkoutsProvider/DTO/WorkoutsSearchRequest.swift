//
//  WorkoutsSearchRequest.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/7/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class WorkoutsSearchRequest: NSObject {
    
    let searchText: String
    
    /// Set to 'true' if your intent is to search templates for new workout.
    let isTemplates: Bool
    
    required init(searchText: String, isTemplates: Bool) {
        self.searchText = searchText
        self.isTemplates = isTemplates
        super.init()
    }
}

extension WorkoutsSearchRequest {
    
    func requestBySettingSearchText(searchText: String) -> Self {
        return self.dynamicType.init(searchText: searchText, isTemplates: isTemplates)
    }
    
    func requestBySettingTemplatesCondition(isTemplates: Bool) -> Self {
        return self.dynamicType.init(searchText: searchText, isTemplates: isTemplates)
    }
}

extension WorkoutsSearchRequest {
    
    class func emptyRequest() -> Self {
        return self.init(searchText: "", isTemplates: false)
    }
    
    class func emptyTemplatesRequest() -> Self {
        return self.init(searchText: "", isTemplates: true)
    }
}
