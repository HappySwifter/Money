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
    @Binding var selectedAccount: Account?
    @Binding var presentingType: PresentingType
        
    enum ButtonType: String, CaseIterable {
        case newIncome = "🏦 New income"
        case accountToCategory = "🏦 Account \u{2192} 🍔 Category"
        case accountToAccount = "🏦 Account \u{2192} 🏦 Account"
        case newAccount = "🏦 Account"
        case newCategory = "🍔 Category"
        case charts = "Charts"
        case settings = "Settings"
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
                if button == .charts {
                    Divider()
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
            Image(systemName: "line.3.horizontal")
                .font(.title3)
                .foregroundColor(.white)
                .padding(15)
                .background(Color.blue.opacity(0.3))
                .clipShape(Circle())
        }
        .menuOrder(.fixed)
        .menuStyle(RedBorderMenuStyle())
        .dynamicTypeSize(.xLarge ... .xLarge)
    }
    
    private func press(type: ButtonType) {
        switch type {
        case .newIncome:
            if let selectedAccount {
                presentingType = .newIncome(destination: selectedAccount)
            }
        case .accountToCategory:
            if let selectedAccount {
                Task { @MainActor in
                    if let destCategory = try await getDestination(isAccount: false, notId: selectedAccount.id) {
                        presentingType = .transfer(source: selectedAccount, destination: destCategory)
                    } else {
                        presentingType = .addCategory
                    }
                }
            }
        case .accountToAccount:
            Task { @MainActor in
                if let selectedAccount, let destAccount = try await getDestination(isAccount: true, notId: selectedAccount.id) {
                    presentingType = .transfer(source: selectedAccount, destination: destAccount)
                }
            }
        case .newAccount:
            presentingType = .addAccount
        case .newCategory:
            presentingType = .addCategory
        case .charts:
            presentingType = .charts
        case .settings:
            presentingType = .settings
        }
    }

    private func getDestination(isAccount: Bool, notId: UUID) async throws -> Account? {
        guard let dataHandler = dataHandler else {
            return nil
        }
        let pred = Account.menuListDestinationAccountPredicate(
            isAccount: isAccount,
            notId: notId)
        return try await dataHandler.getAccounts(with: pred, fetchLimit: 1).first
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
