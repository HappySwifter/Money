//
//  AddDataHelperView.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import SwiftUI

struct AddDataHelperView: View {
    @Environment(AppRootManager.self) private var appRootManager
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Welcome to the My Money app!")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.vertical)
            
            IconView(icon: Icon(name: "tree.fill", color: .black, isMulticolor: true), font: .system(size: 200))
            
            Spacer()
            
            Text("Start by adding some accounts and categories.\nHere is two options how to do that")
                .font(.title3)
                .padding(.bottom)
            
            Button {
                
            } label: {
                Text("Add test data")
            }
            .buttonStyle(StretchedRoundedButtonStyle())
            .padding(.bottom)
            
            Button {
                appRootManager.currentRoot = .addAccount
            } label: {
                Text("I will create by myself")
            }
            .buttonStyle(StretchedRoundedButtonStyle())
        }
        .padding()
    }
}

#Preview {
    AddDataHelperView()
}
