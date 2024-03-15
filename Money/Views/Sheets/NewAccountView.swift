//
//  NewAccountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import MCEmojiPicker
import SwiftData

struct NewAccountView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Preferences.self) private var preferences
    @Environment(CurrenciesApi.self) private var currenciesApi
    
    @Binding var isSheetPresented: Bool
    @State private var isEmojiPickerPresented = false
    @State private var isCurrencyPickerPresented = false
    
    @State var account = Account(orderIndex: 0,
                                 name: "",
                                 icon: "🏦",
                                 color: SwiftColor.allCases.randomElement()!,
                                 isAccount: true,
                                 amount: 0,
                                 currency: nil)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30, content: {
                    
                    AccountView(item: account,
                                selected: .constant(false),
                                longPressHandler: nil)
                    
                    HStack {
                        Button(account.icon) {
                            isEmojiPickerPresented.toggle()
                        }
                        .font(.title)
                        .padding(10)
                        .background(Color(red: 0.98, green: 0.96, blue: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .emojiPicker(
                            isPresented: $isEmojiPickerPresented,
                            selectedEmoji: $account.icon,
                            arrowDirection: .up
                        )
                        .aspectRatio(1, contentMode: .fill)
                        
                        TextField("Name", text: $account.name)
                            .font(.title3)
                            .padding(15)
                            .background(Color(red: 0.98, green: 0.96, blue: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            .keyboardType(.asciiCapable)
                            .autocorrectionDisabled()
                            .scrollDismissesKeyboard(.interactively)
                    }
                    
                    HStack {
                        Button(account.currency?.symbol ?? "") {
                            isCurrencyPickerPresented = true
                        }
                        .font(.title)
                        .padding(10)
                        .background(Color(red: 0.98, green: 0.96, blue: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        
                        TextField("Amount", text: Binding(get: {
                            String(format: "%.0f", account.amount)
                        }, set: {
                            account.setInitial(amount: Double($0) ?? 0)
                        }))
                        .font(.title3)
                        .padding(15)
                        .background(Color(red: 0.98, green: 0.96, blue: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .keyboardType(.decimalPad)
                        .scrollDismissesKeyboard(.interactively)
                    }
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 50)), count: 6), alignment: .center) {
                            ForEach(SwiftColor.allCases, id: \.self) { color in
                                color.value
                                    .clipShape(Circle())
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
//                                    .frame(width: 50, height: 50)
                                    .opacity(account.color == color.rawValue ? 1 : 0.3)
                                    .onTapGesture {
                                        account.color = color.rawValue
                                    }
                            }
                        }
                    }
                })
                .padding()
            }
            .onAppear {
                account.currency = preferences.getUserCurrency()
            }
            .sheet(isPresented: $isCurrencyPickerPresented, content: {
                NavigationStack {
                    CurrencyPicker(selectedCurrency: Binding(get: {
                        account.currency!
                    }, set: {
                        account.currency = $0
                    }))
                }
            })
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isSheetPresented.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCategory()
                        isSheetPresented.toggle()
                    }
                    .disabled(account.name.isEmpty)
                }
            }
            .navigationTitle("New account")
        }
        
    }
    
    func saveCategory() {
        guard !account.name.isEmpty else {
            print("name is empty")
            return
        }
        do {
            let accDesc = FetchDescriptor<Account>()
            let accountsCount = try modelContext.fetchCount(accDesc)
            account.orderIndex = accountsCount
            modelContext.insert(account)
        } catch {
            print(error)
        }

    }
}

//#Preview {
//    NewAccountView(isSheetPresented: .constant(true))
//        .modelContainer(MoneyApp().sharedModelContainer)
//        .environment(MoneyApp().currencyApi)
//}
