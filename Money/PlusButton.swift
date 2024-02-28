//
//  PlusButton.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct PlusButton: View {
    @Binding var location: CGPoint
    
    var body: some View {
        VStack {
            Text(prettify(location: location))
            Image(systemName: "plus")
                .font(.system(size: 35))
                .foregroundColor(.white)
                .padding(15)
                .background(Color.green)
                .clipShape(Circle())
        }
    }
    
    func prettify(location: CGPoint?) -> String {
        guard let location = location else { return "" }
        return "\(String(format: "%.0f", location.x)) \(String(format: "%.0f", location.y))"
    }
    
}

#Preview {
    PlusButton(location: .constant(.zero))
}
