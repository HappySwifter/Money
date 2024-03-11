import SwiftUI

struct Constants {
}

func prettify(size: CGSize?) -> String {
    guard let size = size else { return "" }
    return "\(String(format: "%.0f", size.width)) \(String(format: "%.0f", size.height))"
}

func prettify(location: CGPoint?) -> String {
    guard let location = location else { return "" }
    return "\(String(format: "%.0f", location.x)) \(String(format: "%.0f", location.y))"
}

func prettify(val: Double?, fractionLength: Int = 0) -> String {
    guard let val = val else { return "" }
    return val.formatted(
        .number
        .precision(.fractionLength(fractionLength))
    )
}

func getAmountStringWith(code: String, val: Double, fractionLength: Int = 0) -> String {
    return val.formatted(
        .currency(code: code)
        .precision(.fractionLength(0))
    )
}

extension Double {
    func getString(minFraction: Int = 0, maxFraction: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = minFraction
        formatter.maximumFractionDigits = maxFraction
        return formatter.string(from: NSNumber(value: self))!
    }
}

extension String {
    func toDouble() -> Double? {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        return formatter.number(from: self)?.doubleValue
    }
}

extension Date {
    var ratesDateString: String {
        let form = DateFormatter()
        form.dateFormat = "YYYY-MM-dd"
        return form.string(from: self)
    }
}

func showImpact() {
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

