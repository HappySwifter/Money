//
//  HistoryErrorView.swift
//  Money
//
//  Created by Artem on 16.07.2024.
//

import SwiftUI

struct HistoryErrorView: View {
    let error: Error
    
    var body: some View {
        Text("Error: \(error.localizedDescription)")
    }
}

//#Preview {
//    HistoryErrorView(error: Error()
//}
