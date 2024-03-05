import SwiftUI
/*:
 ****
SwiftUI Essentials
 ****
 Generating array
 */
let arrayOfStrings: [Int] = Array(repeating: .init(0), count: 10)
/*:
 Safe subscript on array
 */
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
/*:
 Text field become first responder
 */
struct MyView: View {
    enum FocusField: Hashable {
      case field
    }
    @FocusState private var focusedField: FocusField?
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
            .focused($focusedField, equals: .field)
            .onAppear {
                self.focusedField = .field
            }
    }
}
