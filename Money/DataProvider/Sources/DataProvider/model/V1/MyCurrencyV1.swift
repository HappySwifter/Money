import Foundation

//public typealias MyCurrency = SchemaV1.MyCurrency


public final class MyCurrency: Sendable, Equatable, Hashable {
    public let code: String
    public let name: String
    public let symbol: String
    
    public static func == (lhs: MyCurrency, rhs: MyCurrency) -> Bool {
        lhs.code == rhs.code
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
    
    public init(code: String, name: String, symbol: String?) {
        self.code = code
        self.name = name
        self.symbol = symbol ?? String(code.prefix(2))
    }
}

