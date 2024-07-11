//
//  SymbolsView.swift
//  Money
//
//  Created by Artem on 09.07.2024.
//

import SwiftUI

private enum CurrencyViewMode: String, CaseIterable {
    case normal
    case circle
    case square
    
    var modifierName: String? {
        switch self {
        case .normal:
            return nil
        case .circle, .square:
            return rawValue
        }
    }
}

struct SymbolPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showModifiersList = true
    @State private var isFill = false
    @State private var selectedName = ""
    @State private var selectedColor = SwiftColor.green
    @State private var isMultiColor = false
    @State private var selectedType = IconType.all
    @State private var iconsToShow = IconType.all.getIcons()
    @State private var currencyViewMode = CurrencyViewMode.normal

    @Binding var selectedIcon: Icon
    
    private var columns: [GridItem] {
        return Array(repeating: .init(.flexible(minimum: 30, maximum: 80)), count: 4)
    }
    
    private var canBeFilled: Bool {
        selectedType != .currencies ||
        selectedType == .currencies && currencyViewMode != .normal
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button {
                    showModifiersList.toggle()
                } label: {
                    Text("Modifiers >")
                }
                Spacer()
                Picker(selection: $selectedType) {
                    ForEach(IconType.allCases, id: \.self) { type in
                        Text(type.title)
                    }
                } label: {}
            }
            
            if showModifiersList {
                ChooseColorView(color: $selectedColor)
                
                if selectedType == .currencies {
                    Picker(selection: $currencyViewMode) {
                        ForEach(CurrencyViewMode.allCases, id: \.self) { cur in
                            Text(cur.rawValue.capitalized)
                        }
                    } label: {}
                    .pickerStyle(.segmented)
                } else {
                    Toggle("Multicolor", isOn: $isMultiColor)
                }
                if canBeFilled {
                    Toggle("Fill", isOn: $isFill)
                }
            }
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(iconsToShow, id: \.self) { icon in
                        IconView(icon: Icon(name: getModifiedName(icon),
                                            color: selectedColor,
                                            isMulticolor: isMultiColor))
                        .onTapGesture {
                            selectedName = icon
                        }
                        .padding(15)
                        .cornerRadiusWithBorder(radius: 5,
                                                borderLineWidth: Icon.isBaseNameSame(lhs: selectedName, rhs: icon) ? 1 : 0,
                                                borderColor: selectedColor.value)
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            let baseIconName = selectedIcon.removed(modifiers: Icon.Modifiers.allCases)
            selectedType = IconType.findTypeBy(baseIconName: baseIconName)
            selectedName = baseIconName

            isFill = selectedIcon.contains(modifier: .fill)
            if selectedIcon.contains(modifier: .circle) {
                currencyViewMode = .circle
            } else if selectedIcon.contains(modifier: .square) {
                currencyViewMode = .square
            }
            
            selectedColor = selectedIcon.color
            isMultiColor = selectedIcon.isMulticolor
        }
        .onChange(of: selectedType) {
            iconsToShow = selectedType.getIcons()
        }
        .padding()
        .navigationTitle("Icon")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    saveIcon()
                    dismiss()
                }, label: {
                    Text("Save")
                })
            }
        }
    }
        
    private func getModifiedName(_ name: String) -> String {
        var name = name
        if selectedType == .currencies {
            appendUniqueModifier(name: &name, mod: currencyViewMode.modifierName)
        }
        if isFill && canBeFilled {
            appendUniqueModifier(name: &name, mod: Icon.Modifiers.fill.rawValue)
        }
        print(name)
        return name
    }
    
    private func appendUniqueModifier(name: inout String, mod: String?) {
        if let mod, !name.contains(".\(mod)") {
            name += ".\(mod)"
        }
    }
    
    private func saveIcon() {
        selectedIcon.name = getModifiedName(selectedName)
        selectedIcon.color = selectedColor
        selectedIcon.isMulticolor = isMultiColor
    }
}

#Preview {
    NavigationStack {
        SymbolPickerView(selectedIcon: .constant(Icon(name: "doc", color: .blue, isMulticolor: true)))
    }
    
}
