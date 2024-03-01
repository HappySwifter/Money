//
//  DropableView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI

struct DropableView: View {
    @Binding var highlighted: Bool
    let type: CircleType
    
    var body: some View {
        HStack {
            Text("Add \(type.description)")
            Image(systemName: "plus")
                .font(.system(size: highlighted ? 20 : 15))
                .foregroundColor(.white)
                .padding(15)
                .background(Color.gray.opacity(highlighted ? 0.6 : 0.4))
                .clipShape(Circle())
            Spacer()
        }
    }
}

#Preview {
    DropableView(highlighted: .constant(false), type: .account)
}
