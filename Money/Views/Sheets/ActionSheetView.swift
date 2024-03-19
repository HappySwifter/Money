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
            case .newIncome(let destination):
                NewIncomeView(
                    destination: destination,
                    isSheetPresented: $isPresented)
            case .transfer(let source, let destination):
                TransferMoneyView(
                    source: source,
                    destination: destination!,
                    isSheetPresented: $isPresented)
            case .details(let item):
                if item.isAccount {
                    AccountDetailsView(account: item)
                } else {
                    CategoryDetailsView(
                        isSheetPresented: $isPresented,
                        item: item)
                }
            case .addAccount:
                NewAccountView(isSheetPresented: $isPresented)
            case .addCategory:
                NewCategoryView(isSheetPresented: $isPresented)
            case .none:
                Spacer()
            }
        }
        .presentationCornerRadius(20)
    }
}

#Preview {
    ActionSheetView(isPresented: .constant(true), presentingType: .addAccount)
}
