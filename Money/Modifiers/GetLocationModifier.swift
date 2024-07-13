//
//  GetLocationModifier.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI

extension View {
    func getRect(result: @escaping (CGRect) -> ()) -> some View {
        modifier(GetOriginModifier())
            .onPreferenceChange(OriginKey.self, perform: result)
    }
}

private struct GetOriginModifier: ViewModifier {
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

private struct OriginKey: PreferenceKey {
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
    static var defaultValue: CGRect = .zero
}
