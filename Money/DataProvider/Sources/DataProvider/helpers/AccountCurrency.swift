import Foundation

public final class AccountCurrency: Sendable, Hashable, CustomStringConvertible {
    public let code: String
    public let name: String
    public let symbol: String
    
    public static func == (lhs: AccountCurrency, rhs: AccountCurrency) -> Bool {
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
    
    public var description: String {
        "\(code) \(name) \(symbol)"
    }
}

