//
//  AccountDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI
import SwiftData

struct AccountDetailsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) private var modelContext
    private static var descriptor: FetchDescriptor<Account> {
        var descriptor = FetchDescriptor<Account>()
        let predicate = #Predicate<Account> { $0.isAccount }
        descriptor.predicate = predicate
        descriptor.fetchLimit = 1
        return descriptor
    }
    @Query(descriptor) var destinationAccount: [Account]
    @State var isTransferViewPresented = false
    let account: Account
    
    var body: some View {
        VStack {
            Text("Details: \(account.name)")
            Button {
                isTransferViewPresented.toggle()
            } label: {
                Text("Transfer money to another account")
            }

            Spacer()
            Button("Delete") {
                withAnimation {
                    modelContext.delete(account)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .buttonStyle(DeleteButton())
        }
        .sheet(isPresented: $isTransferViewPresented) {
            TransferMoneyView(source: account,
                              destination: destinationAccount.first!,
                              isSheetPresented: $isTransferViewPresented)
        }
    }
}
