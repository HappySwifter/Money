//
//  AccountDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI
import SwiftData

struct AccountDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
//    @State var isTransferViewPresented = false
    @State var account: Account
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                AccountView(item: account,
                            currency: .constant(account.currency),
                            selected: .constant(false),
                            longPressHandler: nil)
                NewAccountEmojiAndNameView(account: $account)
                NewAccountChooseColorView(account: $account)
                
                Spacer()
                //                Button("Hide") {
                //                    withAnimation {
                //                        account.isHidden = true
                //                        presentationMode.wrappedValue.dismiss()
                //                    }
                //                }
                //                .buttonStyle(DeleteButton())
                
//                Button {
//                    isTransferViewPresented.toggle()
//                } label: {
//                    Text("Transfer money to another account")
//                }
            }
            .padding()
        }
//        .fullScreenCover(isPresented: $isTransferViewPresented, content: {
//            TransferMoneyView(source: account,
//                              destination: getDestAccount(),
//                              isSheetPresented: $isTransferViewPresented)
//        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
    
    func getDestAccount() -> Account {
        var desc = FetchDescriptor<Account>()
        desc.fetchLimit = 1
        let predicate = #Predicate<Account> { $0.isAccount }
        desc.predicate = predicate
        return try! modelContext.fetch(desc).first!
    }
}
