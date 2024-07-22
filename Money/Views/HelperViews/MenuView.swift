//
//  DropableView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI
import DataProvider

@MainActor
struct MenuView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    let selectedAccount: Account?
    @Binding var presentingType: PresentingType
    @State private var firstAccount: Account?
    @State private var firstCategory: Account?
    
    enum ButtonType: String, CaseIterable {
        case newIncome = "🏦 New income"
        case accountToCategory = "🏦 Account \u{2192} 🍔 Category"
        case accountToAccount = "🏦 Account \u{2192} 🏦 Account"
        case newAccount = "🏦 Account"
        case newCategory = "🍔 Category"
    }
    
    
    var body: some View {
        Menu {
            ForEach(ButtonType.allCases, id: \.self) { button in
                if button == .accountToCategory {
                    Divider()
                    Text("Transfer")
                }
                if button == .newAccount {
                    Divider()
                    Text("Create new")
                }
                Button {
                    press(type: button)
                } label: {
                    Group {
                        Text(button.rawValue)
                    }
                }
                .buttonStyle(MyButtonStyle())
            }
        } label: {
            Image(systemName: "plus")
                .font(.title3)
                .foregroundColor(.white)
                .padding(15)
                .background(Color.blue.opacity(0.3))
                .clipShape(Circle())
        }
        .menuOrder(.fixed)
        .menuStyle(RedBorderMenuStyle())
        .task {
            guard let selectedAccountId = selectedAccount?.id else { return }
            do {
                try await self.firstAccount = getDestination(isAccount: true, notId: selectedAccountId)
                try await self.firstCategory = getDestination(isAccount: false, notId: selectedAccountId)
            } catch {
                print( error)
            }
        }
    }
    
    private func press(type: ButtonType) {
        switch type {
        case .newIncome:
            if let selectedAccount {
                presentingType = .newIncome(destination: selectedAccount)
            }
        case .accountToCategory:
            if let selectedAccount {
                if let dest = firstCategory {
                    presentingType = .transfer(source: selectedAccount, destination: dest)
                } else {
                    presentingType = .addCategory
                }
            }
        case .accountToAccount:
            if let selectedAccount, let dest = firstAccount {
                presentingType = .transfer(source: selectedAccount, destination: dest)
            }
        case .newAccount:
            presentingType = .addAccount
        case .newCategory:
            presentingType = .addCategory
        }
    }

    private func getDestination(isAccount: Bool, notId: UUID) async throws -> Account? {
        if let dataHandler = await dataHandler() {
            let pred = #Predicate<Account> {
                $0.isAccount == isAccount &&
                $0.id != notId
            }
            return try await dataHandler.getAccounts(with: pred, fetchLimit: 1).first
        } else {
            return nil
        }
    }
}


struct RedBorderMenuStyle : MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
//            .padding(3)
//            .border(Color.red)
//            .background(Color.black.opacity(0.5))
    }
}

struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(configuration.isPressed ? .blue : .red)
            .background(Color(configuration.isPressed ? .gray : .yellow))
            .opacity(configuration.isPressed ? 1 : 0.75)
            .clipShape(Capsule())
    }
}
