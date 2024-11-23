////
////  CurrencyFieldView.swift
////  Money
////
////  Created by Artem on 23.11.2024.
////
//
//import SwiftUI
//
//struct CurrencyFieldView: View {
//    var body: some View {
//        HStack {
//            if let currency {
//                Text(currency.code.uppercased())
//                    .fontWeight(.bold)
//                Text("- \(currency.name)")
//            } else {
//                Text("Select currency")
//            }
//            Spacer()
//            Image(systemName: "chevron.down")
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadiusWithBorder(radius: Constants.fieldCornerRadius)
//        .onTapGesture {
//            isCurrencySelectorPresented.toggle()
//        }
//    }
//}
//
//#Preview {
//    CurrencyFieldView()
//}
