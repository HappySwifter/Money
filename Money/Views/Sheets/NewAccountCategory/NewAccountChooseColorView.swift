//
//  NewAccountChooseColorView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI

struct NewAccountChooseColorView: View {
    @Binding var account: Account
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 50)), count: 6), alignment: .center) {
                ForEach(SwiftColor.allCases, id: \.self) { color in
                    color.value
                        .clipShape(Circle())
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .opacity(account.color == color.rawValue ? 1 : 0.3)
                        .onTapGesture {
                            account.color = color.rawValue
                        }
                }
            }
        }
    }
}

struct ChooseColorView: View {
    @Binding var color: SwiftColor
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(SwiftColor.allCases, id: \.self) { color in
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
