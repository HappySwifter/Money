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
    @State private var selectedMonth = ""
    @State private var selectedYear = ""
    
    @State private var pieChartSelectedSector: PieChartValue?
    
    @State private var data = [
        PieChartValue(amount: 50, title: "Lunches", data: []),
        PieChartValue(amount: 20, title: "Food", data: []),
        PieChartValue(amount: 100, title: "Rent", data: []),
        PieChartValue(amount: 50, title: "Car", data: []),
        PieChartValue(amount: 5, title: "Girl", data: [])
    ]
    
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
                            ForEach(expensesService.availableMonths, id: \.self) { Text($0) }
                        }
                    case .year:
                        Picker("", selection: $selectedYear) {
                            ForEach(expensesService.availableYears, id: \.self) { Text($0) }
                        }
                    }
                }
            }
            .padding()

            ChartView(data: $data, selectedSector: $pieChartSelectedSector)
            if let pieChartSelectedSector {
                Button {
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
            self.selectedMonth = expensesService.availableMonths.first ?? ""
            self.selectedYear = expensesService.availableYears.first ?? ""
            updateChart()
        }
        .onChange(of: selectedChartType) {
//            updateChart()
        }
        .onChange(of: selectedPeriodType) {
//            updateChart()
        }
        .onChange(of: selectedDate, initial: false) {
//            updateChart()
        }
        .onChange(of: selectedMonth, initial: false) {
//            updateChart()
        }
        .onChange(of: selectedYear, initial: false) {
//            updateChart()
        }
        .navigationTitle("Report")
    }
    
    func updateChart() {
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
                self.data = try await expensesService.getExpensesFor(timePeriod: .day, value: selectedDate.omittedTime)
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
