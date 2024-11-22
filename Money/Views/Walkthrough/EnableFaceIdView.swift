//
//  EnableFaceIdView.swift
//  Money
//
//  Created by Artem on 21.11.2024.
//

import SwiftUI

struct EnableFaceIdView: View {
    @Environment(AppRootManager.self) private var appRootManager
    
    var body: some View {
        ZStack {
            BackGradientView()
            
            VStack {
                Text("Coming soon")
                Spacer()
                
                Button {
                    appRootManager.currentRoot = .dashboard
                } label: {
                    Text("Finish")
                }
                .buttonStyle(StretchedRoundedButtonStyle(
                    enabledColor: .green,
                    disabledColor: .gray)
                )
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    EnableFaceIdView()
}
