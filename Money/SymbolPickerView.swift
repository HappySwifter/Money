//
//  SymbolsView.swift
//  Money
//
//  Created by Artem on 09.07.2024.
//

import SwiftUI

struct SymbolPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showModifiersList = true
    @State private var isFill = false
    @State private var selectedName = ""
    @State private var selectedColor = SwiftColor.green
    @State private var isMultiColor = false
    @State private var selectedType = IconType.all
    @State private var iconsToShow = IconType.all.getIcons()
    
    @Binding var selectedIcon: Icon
    
    private var columns: [GridItem] {
        return Array(repeating: .init(.flexible(minimum: 30, maximum: 80)), count: 4)
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
                HStack {
                    Toggle("Fill", isOn: $isFill)
                }
                HStack {
                    Toggle("Multicolor", isOn: $isMultiColor)
                }
            }
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(iconsToShow, id: \.self) { icon in
                        IconView(icon: Icon(name: icon,
                                            color: selectedColor,
                                            isFill: isFill,
                                            isMulticolor: isMultiColor))
                        .onTapGesture {
                            selectedName = icon
                        }
                        .padding(15)
                        .cornerRadiusWithBorder(radius: 5, borderLineWidth: selectedName == icon ? 1 : 0, borderColor: selectedColor.value)
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            isFill = selectedIcon.isFill
            selectedName = selectedIcon.name
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
    
    private func saveIcon() {
        selectedIcon.name = selectedName
        selectedIcon.color = selectedColor
        selectedIcon.isFill = isFill
        selectedIcon.isMulticolor = isMultiColor
    }
}

#Preview {
    NavigationStack {
        SymbolPickerView(selectedIcon: .constant(Icon(name: "doc", color: .blue, isFill: true, isMulticolor: true)))
    }
    
}
