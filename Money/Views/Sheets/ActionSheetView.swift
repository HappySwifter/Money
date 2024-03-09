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
                TransferMoneyView(
                    source: source!,
                    destination: destination!,
                    isSheetPresented: $isPresented)
            case .details(let item):
                switch item.type {
                case .account:
                    AccountDetailsView(account: item as! Account)
                case .category:
                    CategoryDetailsView(
                        isSheetPresented: $isPresented,
                        item: item as! SpendCategory)
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
//        .padding()
        .presentationCornerRadius(30)
        .presentationDetents([.fraction(presentingType.sheetHeightFraction)])
        
    }
}

#Preview {
    ActionSheetView(isPresented: .constant(true), presentingType: .addAccount)
}
