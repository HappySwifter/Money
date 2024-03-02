//
//  DecimalPadView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI

enum CalculatorButtons: String, CaseIterable {
    
    case but7 = "7"
    case but8 = "8"
    case but9 = "9"
    case plus = "+"
    case but4 = "4"
    case but5 = "5"
    case but6 = "6"
    case minus = "-"
    case but1 = "1"
    case but2 = "2"
    case but3 = "3"
    case equal = "="
    case comma = ","
    case but0 = "0"
    case remove = "\u{232b}"
    
    var backgroundColor: Color {
        switch self {
        case .plus, .minus, .equal:
            return .orange
        default:
            return .gray.opacity(0.8)
        }
    }
}

struct CalculatorView: View {
    
    @Binding var resultString: String
    let digits = CalculatorButtons.allCases
    let columns: [GridItem] = Array(repeating: GridItem(.fixed(60), spacing: 0), count: 4)
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 0, content: {
                Section {
                    Group {
                        ForEach(digits, id: \.self) { number in
                            Button(action: {
                                if !(number.rawValue == "," && resultString.contains(",")) {
                                    resultString.append(number.rawValue)
                                }
                                
                            }, label: {
                                CalculatorButtonView(button: number)
                            })
                        }
                    }
                } header: {
                    HStack {
                        TextField("Enter amount", text: $resultString)
                            .font(.title)
                            .disabled(true)
                            .multilineTextAlignment(.trailing)
                        
                        
                    }
                    .padding(.vertical)
                }
            })
            .clipShape(RoundedRectangle(cornerRadius: 15.0))
            .frame(width: 220)
            
        }
    }
    
}

#Preview {
    @State var res = "324560"
    return CalculatorView(resultString: $res)
}
