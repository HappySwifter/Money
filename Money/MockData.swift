//
//  MockData.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI

struct MockData {
    
    static let mockCurrency = MyCurrency(code: "", name: "", icon: "")
    
    static let columns = [
        GridItem(.adaptive(minimum: 60, maximum: 200)),
        GridItem(.adaptive(minimum: 60, maximum: 200)),
        GridItem(.adaptive(minimum: 60, maximum: 200)),
        GridItem(.adaptive(minimum: 60, maximum: 200)),
    ]
}


