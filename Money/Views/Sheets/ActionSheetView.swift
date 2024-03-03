//
//  ActionSheetView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI

struct ActionSheetView: View {
    @Binding var isPresented: Bool
    let presentingType: PresentingType
    
    var body: some View {
        VStack {
            switch presentingType {
            case .transfer(let source, let destination):
                HStack {
                    if source?.type == .plusButton {
                        Text("New income")
                    } else {
                        Text(source?.name ?? "")
                    }
                    Text("->")
                    Text(destination?.name ?? "")
                }
            case .details(let item):
                switch item.type {
                case .account:
                    AccountDetailsView(item: item)
                case .category:
                    CategoryDetailsView(item: item)
                default:
                    Color.red
                }
            case .addAccount:
                NewAccountView(isSheetPresented: $isPresented)
            case .addCategory:
                NewCategoryView(isSheetPresented: $isPresented)
            case .none:
                Spacer()
            }
            Spacer()
        }
        .padding()
        .presentationCornerRadius(30)
        .presentationDetents([.height(380)])
        
    }
}

#Preview {
    ActionSheetView(isPresented: .constant(true), presentingType: .addAccount)
}
