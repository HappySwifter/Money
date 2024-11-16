//
//  ReportTableView.swift
//  Money
//
//  Created by Artem on 21.05.2024.
//

import SwiftUI

struct ReportTableView: View {
    @Environment(Preferences.self) private var preferences
    @Binding var data: [PieChartValue]
    @Binding var selectedSector: PieChartValue?
    @State private var userCurrencySymbol = ""
    
    var body: some View {
        VStack {
            if let selectedSector {
                Button {
                    showImpact()
                    withAnimation {
                        self.selectedSector = nil
                    }
                } label: {
                    Text("Clear filter")
                }
                List(groupByDate(for: selectedSector), id: \.date) { tranByDate in
                    Section {
                        ForEach(tranByDate.transactions) { tran in
                            if let source = tran.source, let dest = tran.destination {
                                SpengingView(transaction: tran,
                                             source: source,
                                             destination: dest)
                            }
    //                        HStack {
    //                            VStack(alignment: .leading) {
    //                                Text("\(tran.source.icon) \(tran.source.name)")
    //                                    .foregroundStyle(.primary)
    //                                Text(tran.date.historyDateString)
    //                                    .foregroundStyle(.secondary)
    //                            }
    //                            Spacer()
    //                            Text(tran.sourceAmountText)
    //                                .foregroundStyle(.primary)
    //                        }
                        }
                    } header: {
                        Text(tranByDate.date.historyDateString)
                    }
                }
                
            } else {
                List(data, id: \.title) { element in
                    HStack {
                        Text(element.title)
                        Spacer()
                        Text(String(element.amount))
                        Text(userCurrencySymbol)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showImpact()
                        withAnimation {
                            selectedSector = element
                        }
                        
                    }
                }
            }
        }
        .dynamicTypeSize(.xLarge ... .xLarge)
        .task {
            self.userCurrencySymbol = (try? await preferences.getUserCurrency().symbol) ?? ""
        }
    }
    
    private func groupByDate(for sector: PieChartValue) -> [TransactionsByDate] {
        let filteredForSection = data.first(where: { $0.title == sector.title })?.data ?? []
        return Dictionary(grouping: filteredForSection, by: { $0.date.omittedTime })
            .map{ TransactionsByDate(date: $0.key, transactions: $0.value) }
            .sorted { $0.date > $1.date }
    }
}
