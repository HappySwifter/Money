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
    @Environment(CurrenciesApi.self) private var currencyApi
    
    @State var circleItem = Account(name: "",
                                       icon: "🏦",
                                       amount: 0,
                                       currency: Currency(code: "usd", name: "US Dollar", icon: ""),
                                       color: SwiftColor.allCases.first!)
    
    @State var currencies = [Currency]()
    @State var currency = Currency(code: "usd", name: "US Dollar", icon: "")
    
    
    @Binding var isSheetPresented: Bool
    @State private var isEmojiPickerPresented = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30, content: {
                    
                    AccountView(item: circleItem,
                                pressHandler: nil,
                                longPressHandler: nil)
                    
                    HStack {
                        Button(circleItem.icon) {
                            isEmojiPickerPresented.toggle()
                        }
                        .font(.title)
                        .padding(10)
                        .background(Color(red: 0.98, green: 0.96, blue: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .emojiPicker(
                            isPresented: $isEmojiPickerPresented,
                            selectedEmoji: $circleItem.icon,
                            arrowDirection: .up
                        )
                        .aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        
                        TextField("Name", text: $circleItem.name)
                            .font(.title3)
                            .padding(15)
                            .background(Color(red: 0.98, green: 0.96, blue: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            .keyboardType(.asciiCapable)
                            .autocorrectionDisabled()
                    }
                    
                    TextField("Amount", text: Binding(get: {
                        String(format: "%.0f", circleItem.amount)
                    }, set: {
                        circleItem.amount = Double($0) ?? 0
                    }))
                    .font(.title3)
                    .padding(15)
                    .background(Color(red: 0.98, green: 0.96, blue: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    .keyboardType(.decimalPad)
                    
                    if !currencies.isEmpty {
                        CurrencyPicker(currency: $currency)
                    }
                    
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(SwiftColor.allCases, id: \.self) { color in
                                color.value
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                                    .opacity(circleItem.color == color.rawValue ? 1 : 0.3)
                                    .onTapGesture {
                                        circleItem.color = color.rawValue
                                    }
                            }
                        }
                    }
                })
                .padding()
            }
            .onAppear {
                Task {
                    do {
                        if self.currencies.isEmpty {
                            let currencies = try currencyApi.getCurrencies()
                            
                            let locale = Locale.current
                            let currencySymbol = locale.currencySymbol!
                            let currencyCode = locale.identifier
                            print(currencySymbol, currencyCode)
                            if let localeCurrency = currencies.filter({ $0.code.lowercased() == currencySymbol.lowercased() }).first {
                                self.currency = localeCurrency
                            } else {
                                self.currency = currencies.filter({ $0.code.lowercased() == "usd"
                                }).first!
                            }
                            self.currencies = currencies
                        }
                    } catch {
                        print(error)
                    }
                    
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCategory()
                        isSheetPresented.toggle()
                    }
                    .disabled(circleItem.name.isEmpty)
                }
            }
            .navigationTitle("New account")
        }
        
    }
    
    
    func saveCategory() {
        guard !circleItem.name.isEmpty else {
            print("name is empty")
            return
        }
        modelContext.insert(circleItem)
    }
}

#Preview {
    NewAccountView(isSheetPresented: .constant(true))
        .modelContainer(MoneyApp().sharedModelContainer)
        .environment(MoneyApp().currencyApi)
}
