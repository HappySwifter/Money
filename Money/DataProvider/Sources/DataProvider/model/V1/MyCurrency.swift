//
//  File.swift
//  DataProvider
//
//  Created by Artem on 21.11.2024.
//

import Foundation
import SwiftData


public typealias MyCurrency = SchemaV1.MyCurrency

extension SchemaV1 {
    @Model
    public final class MyCurrency: Sendable {
        public let id: UUID = UUID()
        public let name = ""
        public var rateToBaseCurrency = 0.0
        public var isBase = false
        
        
        public init(name: String, rateToBaseCurrency: Double, isBase: Bool)
        {
            self.name = name
            self.rateToBaseCurrency = rateToBaseCurrency
            self.isBase = isBase
        }
    }
}
