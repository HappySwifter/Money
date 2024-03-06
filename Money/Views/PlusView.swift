//
//  DropableView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI

struct PlusView: View {
    @Binding var buttonPressed: Bool
    
    var body: some View {
        Button {
            buttonPressed.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.title3)
                .foregroundColor(.white)
                .padding(15)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
        }
    }
}

