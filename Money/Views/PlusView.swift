//
//  DropableView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI
import SwiftData

struct PlusView: View {
    @Environment(\.modelContext) private var modelContext
    let selectedAccount: Account?
    @Binding var buttonPressed: Bool
    @Binding var presentingType: PresentingType
    
    enum ButtonType: String, CaseIterable {
        case newIncome = "New income"
        case accountToCategory = "Account -> Category"
        case accountToAccount = "Account -> Account"
        case newAccount = "Account"
        case newCategory = "Category"
        
        var icon: String {
            switch self {
            case .newIncome:
                return "🏦"
            case .accountToCategory:
                return "🏦"
            case .accountToAccount:
                return "🏦"
            case .newAccount:
                return "🏦"
            case .newCategory:
                return "🍔"
            }
        }
    }
    
    
    var body: some View {
        Menu {
            ForEach(ButtonType.allCases, id: \.self) { button in
                if button == .newAccount {
                    Divider()
                    Text("Create new")
                }
                Button {
                    press(type: button)
                } label: {
                    Group {
                        Text("\(button.icon) \(button.rawValue)")
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
    }
    
    private func press(type: ButtonType) {
        switch type {
        case .newIncome:
            if let selectedAccount {
                presentingType = .newIncome(destination: selectedAccount)
            }
        case .accountToCategory:
            if let selectedAccount, let dest = getDestination(isAccount: false, notId: selectedAccount.id) {
                presentingType = .transfer(source: selectedAccount, destination: dest)
            }
        case .accountToAccount:
            if let selectedAccount, let dest = getDestination(isAccount: true, notId: selectedAccount.id) {
                presentingType = .transfer(source: selectedAccount, destination: dest)
            }
        case .newAccount:
            presentingType = .addAccount
        case .newCategory:
            presentingType = .addCategory
        }
    }
    
    private func getDestination(isAccount: Bool, notId: UUID) -> Account? {
        var desc = FetchDescriptor<Account>()
        let pred = #Predicate<Account> {
            $0.isAccount == isAccount &&
            $0.id != notId
        }
        desc.predicate = pred
        return try? modelContext.fetch(desc).first
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
