//
//  File.swift
//  
//
//  Created by Artem on 20.07.2024.
//

import Foundation
import SwiftData

public typealias MyCurrency = SchemaV1.MyCurrency

extension SchemaV1 {
    @Model
    public final class MyCurrency: Sendable {
        public let code: String
        public let name: String
        public let symbol: String
        
        public init(code: String, name: String, symbol: String?) {
            self.code = code
            self.name = name
            self.symbol = symbol ?? String(code.prefix(2))
        }
    }
}
