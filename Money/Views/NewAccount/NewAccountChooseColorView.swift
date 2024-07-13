//
//  NewAccountChooseColorView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI

struct NewAccountChooseColorView: View {
    @Binding var account: Account
    let isCategory: Bool
    @State private var colorsArray = [SwiftColor]()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 50)), count: 6), alignment: .center) {
                ForEach(colorsArray, id: \.self) { color in
                    Group {
                        if color == .clear {
                            Image("clear_color_icon")
                                .resizable()
                        } else {
                            color.value
                        }
                    }
                        .clipShape(Circle())
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .opacity(account.color == color.rawValue ? 1 : 0.3)
                        .background(.gray.opacity(0.01))
                        .onTapGesture {
                            account.color = color.rawValue
                        }
                }
            }
        }
        .onAppear {
            colorsArray = SwiftColor.allCases.filter { isCategory ? $0 != .black : $0 != .clear }
        }
    }
}

struct ChooseColorView: View {
    @Binding var color: SwiftColor
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(SwiftColor.allCases.filter { $0 != .clear }, id: \.self) { color in
                    color.value
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                        .opacity(self.color == color ? 1 : 0.3)
                        .onTapGesture {
                            self.color = color
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
