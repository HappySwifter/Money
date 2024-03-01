//
//  GetLocationModifier.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI

extension View {
    func getRect() -> some View {
        modifier(GetOriginModifier())
    }
}

struct GetOriginModifier: ViewModifier {
//    @Binding var origin: CGRect
//    func body(content: Content) -> some View {
//        content
//            .background(
//                GeometryReader { proxy in
//                    let frame = proxy.frame(in: .named("screen"))
//                    Color.clear
//                        .task(id: frame) {
//                            $origin.wrappedValue = frame
//                        }
//                }
//            )
//    }
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: OriginKey.self, value: proxy.frame(in: .named("screen")))
                }
            )
    }
}

struct OriginKey: PreferenceKey {
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
    static var defaultValue: CGRect = .zero
}
