import SwiftUI
import PlaygroundSupport



func currencyName(currencyCode: String) -> String {
    let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode]))
    
    return locale.localizedString(forCurrencyCode: currencyCode) ?? currencyCode
}



currencyName(currencyCode: "TRY")

