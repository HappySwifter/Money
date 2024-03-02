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
