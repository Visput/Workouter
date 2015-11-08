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
    
    required init(searchText: String) {
        self.searchText = searchText
        super.init()
    }
}

extension WorkoutsSearchRequest {
    
    func requestBySettingSearchText(searchText: String) -> Self {
        return self.dynamicType.init(searchText: searchText)
    }
}

extension WorkoutsSearchRequest {
    
    class func emptyRequest() -> Self {
        return self.init(searchText: "")
    }
    
    func isEmpty() -> Bool {
        return searchText == ""
    }
}
