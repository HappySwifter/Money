//
//  DecimalPadView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI

struct DecimalPadView: View {
    
    @Binding var resultString: String
    let digits = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ",", "0", ]
    let columns = [GridItem(.fixed(60)), GridItem(.fixed(60)), GridItem(.fixed(60))]
    
    var body: some View {
        VStack {
            Spacer()
            LazyVGrid(columns: columns, spacing: 0, content: {
                Section {
                    ForEach(digits, id: \.self) { number in
                        Button(action: {
                            if !(number == "," && resultString.contains(",")) {
                                resultString.append(number)
                            }
                            
                        }, label: {
                            Text(number)
                                .frame(width: 30, height: 30, alignment: .center)
                                .padding(10)
                                .font(.headline)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(5)
                        })
                    }
                } header: {
                    HStack {
                        Spacer()
                        Text(resultString)
                            .font(.title)
                        
                    }
                    .padding(.horizontal)
                    
                }
                
                
            })
            .frame(height: 300)
            .background(Color.red.opacity(0.1))
            Spacer()
        }
        
    }
}

#Preview {
    @State var res = "0"
    return DecimalPadView(resultString: $res)
}
