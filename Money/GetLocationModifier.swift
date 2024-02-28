//
//  GetLocationModifier.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI

extension View {
    func getOrigin(_ origin: Binding<CGRect>) -> some View {
        modifier(GetOriginModifier(origin: origin))
    }
}

struct GetOriginModifier: ViewModifier {
    @Binding var origin: CGRect
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    let frame = proxy.frame(in: .named("screen"))
                    Color.clear
                        .task(id: proxy.frame(in: .named("screen"))) {
                            $origin.wrappedValue = frame
                        }
                }
            )
    }
}
