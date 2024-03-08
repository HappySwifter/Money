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

func prettify(val: Double?, code: String, fractionLength: Int = 0) -> String {
    guard let val = val else { return "" }
    return val.formatted(.number
//        .currency(code: code)
        .precision(.fractionLength(0))
    )
}

func showImpact() {
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

