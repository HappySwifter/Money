//
//  ErrorView.swift
//  Money
//
//  Created by Artem on 23.07.2024.
//

import SwiftUI

struct ErrorView: View {
    let networkError: NetworkError
    var retryHandler: () -> ()
    
    var body: some View {
        VStack {
            Text(networkError.description)
            Button(action: retryHandler) {
                Text("Retry")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

#Preview {
    ErrorView(networkError: .noInternet, retryHandler: {})
}
