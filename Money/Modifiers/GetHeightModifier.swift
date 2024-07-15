//
//  GetLocationModifier.swift
//  Money
//
//  Created by Artem on 10.03.2024.
//

import Foundation
import SwiftUI

//extension View {
//    func getHeight(result: @escaping (CGFloat?) -> ()) -> some View {
//        modifier(GetHeightModifier())
//            .onPreferenceChange(HeightKey.self, perform: result)
//    }
//}
//
//private struct GetHeightModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .overlay(
//                GeometryReader { proxy in
//                    Color.clear
//                        .preference(key: HeightKey.self, value: proxy.size.height)
//                }
//            )
//    }
//}

//private struct HeightKey: PreferenceKey {
//    static var defaultValue: CGFloat?
//
//    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
//        guard let nextValue = nextValue() else { return }
//        value = nextValue
//    }
//}
