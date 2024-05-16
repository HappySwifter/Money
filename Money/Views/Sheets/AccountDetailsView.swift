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
            Button("Hide") {
                withAnimation {
                    account.isHidden = true
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .buttonStyle(DeleteButton())
        }
        .sheet(isPresented: $isTransferViewPresented) {
            TransferMoneyView(source: account,
                              destination: getDestAccount(),
                              isSheetPresented: $isTransferViewPresented)
        }
        .padding()
    }
    
    func getDestAccount() -> Account {
        var desc = FetchDescriptor<Account>()
        desc.fetchLimit = 1
        let predicate = #Predicate<Account> { $0.isAccount }
        desc.predicate = predicate
        return try! modelContext.fetch(desc).first!
    }
}
