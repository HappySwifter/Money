//
//  ChartsView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI

private enum ChartType: String, CaseIterable {
    case expenses = "Expenses"
    case incomes = "Incomes"
}

enum PeriodType: String, CaseIterable {
    case day
    case month
    case year
}

struct ReportView: View {
    @Environment(ExpensesService.self) private var expensesService
    @Environment(Preferences.self) private var preferences
    
    @State private var selectedChartType = ChartType.expenses
    @State private var selectedPeriodType = PeriodType.day
    @State private var selectedDate = Date()
    @State private var selectedMonth = TransactionPeriodType.month(value: Date()).startDate
    @State private var selectedYear = TransactionPeriodType.year(value: Date()).startDate
    @State private var pieChartSelectedSector: PieChartValue?
    @State private var data = [PieChartValue]()
    
    var body: some View {
        VStack {
            HStack {
                Picker(selection: $selectedChartType) {
                    ForEach(ChartType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                } label: {}
                
                if selectedChartType == .expenses {
                    Picker(selection: $selectedPeriodType) {
                        ForEach(PeriodType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    } label: {}
                } else {
                    Spacer()
                }
                
                if selectedChartType == .expenses {
                    switch selectedPeriodType {
                    case .day:
                        DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    case .month:
                        Picker("", selection: $selectedMonth) {
                            ForEach(expensesService.availableMonths, id: \.self) { Text($0.monthYearString) }
                        }
                    case .year:
                        Picker("", selection: $selectedYear) {
                            ForEach(expensesService.availableYears, id: \.self) { Text($0.yearString) }
                        }
                    }
                }
            }
            .padding()

            switch selectedChartType {
            case .expenses:
                ChartView(data: $data, selectedSector: $pieChartSelectedSector)
            case .incomes:
                Color.white
            }
            if let pieChartSelectedSector {
                Button {
                    showImpact()
                    withAnimation {
                        self.pieChartSelectedSector = nil
                    }
                } label: {
                    Text("Clear filter")
                }

                Text("show data for: \(pieChartSelectedSector.title)")
            } else {
                List {
                    ForEach(data, id: \.title) { element in
                        HStack {
                            Text(element.title)
                            Spacer()
                            Text(String(element.amount))
                            Text(preferences.getUserCurrency().symbol)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showImpact()
                            withAnimation {
                                pieChartSelectedSector = element
                            }
                            
                        }
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            updateChart()
        }
        .onChange(of: selectedChartType) {
            updateChart()
        }
        .onChange(of: selectedPeriodType) {
            updateChart()
        }
        .onChange(of: selectedDate) {
            updateChart()
        }
        .onChange(of: selectedMonth) {
            updateChart()
        }
        .onChange(of: selectedYear) {
            updateChart()
        }
        .navigationTitle("Report")
    }
    
    func updateChart(caller: String = #function) {
        print(#function, caller)
        switch selectedChartType {
        case .expenses:
            showExpensesChart()
        case .incomes:
            showIncomesChart()
        }
    }
    
    func showExpensesChart() {
        Task {
            do {
                let period: TransactionPeriodType
                switch selectedPeriodType {
                case .day:
                    period = TransactionPeriodType.day(value: selectedDate)
                case .month:
                    period = TransactionPeriodType.month(value: selectedMonth)
                case .year:
                    period = TransactionPeriodType.year(value: selectedYear)
                }
                self.data = try await expensesService.getExpensesFor(period: period)
            } catch {
                print(error)
            }
        }
        
    }
    
    func showIncomesChart() {
        
    }
    
}

#Preview {
    ReportView()
}
