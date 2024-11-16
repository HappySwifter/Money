import Foundation
import SwiftData

public typealias MyCurrency = SchemaV1.MyCurrency

extension SchemaV1 {
    @Model
    public final class MyCurrency: Sendable {
        public let code = ""
        public let name = ""
        public let symbol = ""
        
//        @Relationship(inverse: \Account.currency)
        private var accounts: [Account]?
        
        public init(code: String, name: String, symbol: String?) {
            self.code = code
            self.name = name
            self.symbol = symbol ?? String(code.prefix(2))
        }
    }
}
