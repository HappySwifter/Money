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