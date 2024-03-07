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
    
    @State var circleItem = Account(name: "",
                                    icon: "🏦",
                                    amount: 0,
                                    currencyCode: "usd",
                                    color: SwiftColor.allCases.first!)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30, content: {
                    
                    AccountView(item: circleItem,
                                selected: .constant(false),
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
                    
                    HStack {
                        Button(circleItem.currencyCode) {
                            isCurrencyPickerPresented = true
                        }
                        .font(.title)
                        .padding(10)
                        .background(Color(red: 0.98, green: 0.96, blue: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        
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
                    self.circleItem.currencyCode = preferences.getUserCurrency().code
                }
            }
            .sheet(isPresented: $isCurrencyPickerPresented, content: {
                CurrencyPicker(isPresented: $isCurrencyPickerPresented,
                               selectedCurrencyCode: $circleItem.currencyCode)
            })
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
