//
//  DropableView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI

struct DropableView: View {
    @Binding var highlighted: Bool
    
    var body: some View {
        HStack {
            Text("Add new")
                .font(.title2)
            Image(systemName: "plus")
                .font(.system(size: highlighted ? 25 : 15))
                .foregroundColor(.white)
                .padding(15)
                .background(Color.gray.opacity(highlighted ? 0.6 : 0.4))
                .clipShape(Circle())
            Spacer()
        }
        .padding(.vertical)
    }
}

#Preview {
    DropableView(highlighted: .constant(false))
}
