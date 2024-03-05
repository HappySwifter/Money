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
    @State var selectedEmoji = "Shoose icon"
    
    @State var currencies = [Currency]()
    @State var currency = Currency(code: "usd", name: "US Dollar", icon: "")

    
    @Binding var isSheetPresented: Bool
    @State private var isEmojiPickerPresented = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25, content: {
                    TextField("Name", text: $name)
                    
                    if !currencies.isEmpty {
                        CurrencyPicker(currency: $currency)
                    }
                    Button(selectedEmoji) {
                        isEmojiPickerPresented.toggle()
                    }.emojiPicker(
                        isPresented: $isEmojiPickerPresented,
                        selectedEmoji: $selectedEmoji,
                        arrowDirection: .down
                    )
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(SwiftColor.allCases, id: \.self) { color in
                                color.value
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                            }
                        }
                        .opacity(0.6)
                        
                    }
                })
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
                    Button("Done") {
                        saveCategory()
                        isSheetPresented.toggle()
                    }
                }
            }
        }

    }
    
    func saveCategory() {
        let color = SwiftColor.allCases.randomElement()
        let item = CircleItem(name: name,
                              icon: selectedEmoji,
                              currency: currency,
                              type: .account,
                              color: color ?? .red)
        modelContext.insert(item)
    }
}

#Preview {
    NewAccountView(isSheetPresented: .constant(true))
        .modelContainer(MoneyApp().sharedModelContainer)
        .environment(MoneyApp().currencyApi)
        .padding()
}
