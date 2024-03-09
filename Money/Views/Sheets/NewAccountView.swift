//
//  NewAccountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import MCEmojiPicker

struct NewAccountView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Preferences.self) private var preferences
    @Environment(CurrenciesApi.self) private var currenciesApi
    
    @Binding var isSheetPresented: Bool
    @State private var isEmojiPickerPresented = false
    @State private var isCurrencyPickerPresented = false
    
    @State var account = Account(name: "",
                                 icon: "🏦",
                                 amount: 0,
                                 currencyCode: "usd",
                                 currencyName: "US Dollar",
                                 currencySymbol: "$",
                                 color: SwiftColor.allCases.first!)
    
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
                        .aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        
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
                        Button(account.currencySymbol) {
                            isCurrencyPickerPresented = true
                        }
                        .font(.title)
                        .padding(10)
                        .background(Color(red: 0.98, green: 0.96, blue: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        
                        TextField("Amount", text: Binding(get: {
                            String(format: "%.0f", account.amount)
                        }, set: {
                            account.amount = Double($0) ?? 0
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
                updateAccountBy(currency: preferences.getUserCurrency())
            }
            .sheet(isPresented: $isCurrencyPickerPresented, content: {
                CurrencyPicker(selectedCurrency: Binding(get: {
                    Currency(code: account.currencyCode,
                             name: account.currencyName,
                             icon: account.currencySymbol)
                }, set: { currency in
                    updateAccountBy(currency: currency)
                }))
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
    
    private func updateAccountBy(currency: Currency) {
        self.account.currencyCode = currency.code
        self.account.currencySymbol = currenciesApi
            .getCurrencySymbol(for: currency.code) ??
            String(account.currencyCode.prefix(2))
        self.account.currencyName = currency.name
    }
    
    func saveCategory() {
        guard !account.name.isEmpty else {
            print("name is empty")
            return
        }
        modelContext.insert(account)
    }
}

#Preview {
    NewAccountView(isSheetPresented: .constant(true))
        .modelContainer(MoneyApp().sharedModelContainer)
        .environment(MoneyApp().currencyApi)
}
