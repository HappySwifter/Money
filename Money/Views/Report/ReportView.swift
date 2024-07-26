//
//  ChartsView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

private enum ChartType: String, CaseIterable {
    case expenses = "Expenses"
    case incomes = "Incomes"
}

enum PeriodType: String, CaseIterable {
    case day = "Day"
    case month = "Month"
    case year = "Year"
}

@MainActor
struct ReportView: View {
    @Environment(ExpensesService.self) private var expensesService
    
    @State private var selectedChartType = ChartType.expenses
    @State private var selectedPeriodType = PeriodType.day
    @State private var selectedDate = Date()
    @State private var selectedMonth = TransactionPeriodType.month(value: Date()).startDate
    @State private var selectedYear = TransactionPeriodType.year(value: Date()).startDate
    @State private var pieChartSelectedSector: PieChartValue?
    @State private var data = [PieChartValue]()
    @State private var networkError: NetworkError?
    @State private var monthsAndYears = (months: [Date](), years: [Date]())

    
    var body: some View {
        VStack {
            if let networkError {
                ErrorView(networkError: networkError) {
                    self.networkError = nil
                    updateChart()
                }
            } else {
                Picker(selection: $selectedChartType) {
                    ForEach(ChartType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                } label: {}
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .disabled(true)
                
                HStack {
                    if selectedChartType == .expenses {
                        Picker(selection: $selectedPeriodType) {
                            ForEach(PeriodType.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        } label: {}
                    }
                    
                    if selectedChartType == .expenses {
                        switch selectedPeriodType {
                        case .day:
                            DatePicker("", selection: $selectedDate,
                                       in: ...Date.now,
                                       displayedComponents: [.date])
                            .labelsHidden()
                        case .month:
                            Picker("", selection: $selectedMonth) {
                                ForEach(monthsAndYears.months, id: \.self) { Text($0.monthYearString) }
                            }
                        case .year:
                            Picker("", selection: $selectedYear) {
                                ForEach(monthsAndYears.years, id: \.self) { Text($0.yearString) }
                            }
                        }
                        Spacer()
                    }
                    
                }
                .padding()
                
                switch selectedChartType {
                case .expenses:
                    SectorChartView(data: $data,
                                    selectedSector: $pieChartSelectedSector)
                case .incomes:
                    Color.white
                }
                ReportTableView(data: $data,
                                selectedSector: $pieChartSelectedSector)
                Spacer()
            }
        }
        .task {
            if let monthsAndYears = try? await expensesService.getSpendingMonthsAndYears() {
                self.monthsAndYears = monthsAndYears
            }
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
    
    func updateChart() {
        pieChartSelectedSector = nil
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
            } catch let error as NetworkError {
                self.networkError = error
            } catch {
                print(error)
            }
        }
    }
    
    func showIncomesChart() {
        
    }
}
