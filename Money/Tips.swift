//
//  Tips.swift
//  Money
//
//  Created by Artem on 16.11.2024.
//

import Foundation
import TipKit
import DataProvider

struct AccountTapTip: Tip {
//    let appRootManager: AppRootManager
    
//    @Parameter
//    var alredy
    

    
    var title: Text {
        Text("Tap on any account to select it")
    }
    
    var message: Text {
        Text("When you create a new spending, app will use selected account")
    }
    
//    var rules: [Rule] {
//        [
//            #Rule(condition: appRootManager.currentRoot == AppRootManager.dashboard)
//        ]
//    }
    
//    var options: [any TipOption] {
//        [MaxDisplayCount(1)]
//    }
}

struct CategoryTapTip: Tip {
    var title: Text {
        Text("Tap on the category to create new spending")
    }
    
    var message: Text {
        Text("When you create a new spending, app will use selected account")
    }
}


struct CategoryLongPressTip: Tip {
    var title: Text {
        Text("Long press on account or category to change details")
    }
}
