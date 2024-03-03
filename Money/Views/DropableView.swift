//
//  DropableView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI

struct DropableView: View {
    let viewModel: DraggableCircleViewModel
    
    var body: some View {
        HStack {
            Text("Add \(viewModel.item.type.addDescription)")
            Image(systemName: "plus")
                .font(.system(size: viewModel.stillState == .focused ? 25 : 15))
                .foregroundColor(.white)
                .padding(15)
                .background(Color.gray.opacity(viewModel.stillState == .focused ? 0.6 : 0.4))
                .clipShape(Circle())
                .getRect()
            Spacer()
        }
        .onPreferenceChange(OriginKey.self, perform: { value in
            viewModel.stillRect = value
        })
    }
}

