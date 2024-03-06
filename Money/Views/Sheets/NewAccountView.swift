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
    
    @State var name = ""
    @State var amount = "0"
    @State var selectedEmoji = "🏦"
    @State var selectedColor = SwiftColor.allCases.first!
    
    @State var circleItem = CircleItem(name: "",
                                       currency: Currency(code: "usd", name: "US Dollar", icon: ""),
                                       type: .account,
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
                        Button(selectedEmoji) {
                            isEmojiPickerPresented.toggle()
                        }
                        .font(.title)
                        .padding(10)
                        .background(Color(red: 0.98, green: 0.96, blue: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .emojiPicker(
                            isPresented: $isEmojiPickerPresented,
                            selectedEmoji: $selectedEmoji,
                            arrowDirection: .up
                        )
                        .aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        
                        TextField("Name", text: $name)
                            .font(.title3)
                            .padding(15)
                            .background(Color(red: 0.98, green: 0.96, blue: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            .keyboardType(.asciiCapable)
                            .autocorrectionDisabled()
                    }

                    TextField("Amount", text: $amount)
                        .font(.title3)
                        .padding(15)
                        .background(Color(red: 0.98, green: 0.96, blue: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .keyboardType(.decimalPad)
                    
                    if !currencies.isEmpty {
                        CurrencyPicker(currency: $currency)
//                            .padding()
                    }
                    
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(SwiftColor.allCases, id: \.self) { color in
                                color.value
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                                    .opacity(selectedColor == color ? 1 : 0.3)
                                    .onTapGesture {
                                        selectedColor = color
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
                }
            }
            .navigationTitle("New account")
        }

    }
    
    func getAccountItem() -> CircleItem {
        CircleItem(name: name,
                         icon: selectedEmoji,
                         amount: Double(amount) ?? 0,
                         currency: currency,
                         type: .account,
                         color: selectedColor)
    }
    
    func saveCategory() {
        let item = getAccountItem()
        modelContext.insert(item)
    }
}

#Preview {
    NewAccountView(isSheetPresented: .constant(true))
        .modelContainer(MoneyApp().sharedModelContainer)
        .environment(MoneyApp().currencyApi)
}
