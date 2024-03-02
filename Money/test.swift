import SwiftUI

struct ContentView2: View {
    let data = (1...10).map { "Item \($0)" }

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ] ) {
            ForEach(data, id: \.self) { item in
                
                
            }
        }
    }
}


#Preview {
    ContentView2()
}


func prettify(location: CGPoint?) -> String {
    guard let location = location else { return "" }
    return "\(String(format: "%.0f", location.x)) \(String(format: "%.0f", location.y))"
}

func showImpact() {
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

