//
//  ChartView.swift
//  Money
//
//  Created by Artem on 20.05.2024.
//

import SwiftUI
import Charts
import DataProvider

struct PieChartValue: Equatable, Hashable {

    let amount: Int
    let title: String
    let color: String
    let data: [MyTransaction]
}

@MainActor
struct SectorChartView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    @State private var pieChartSelectedAngle: Int?
    @Binding var data: [PieChartValue]
    @Binding var selectedSector: PieChartValue?
    @State private var userCurrencySymbol = ""
    
    var body: some View {
        Chart(data, id: \.title) { element in
            SectorMark(
                angle: .value("Expenses", element.amount),
                innerRadius: .ratio(0.6),
                angularInset: 2
            )
            .opacity(selectedSector == nil ? 1.0 : (selectedSector == element ? 1.0 : 0.5))
            .foregroundStyle(SwiftColor(rawValue: element.color)!.value)
            .cornerRadius(10)
            .annotation(position: .overlay) {
                Text(element.title)
                    .font(.caption)
                    .dynamicTypeSize(.xLarge ... .xLarge)
                    .foregroundStyle(Color.white)
            }
        }
        .aspectRatio(1, contentMode: .fit )
        .frame(height: 300)
        .chartBackground { chartProxy in
            if let rect = chartProxy.plotFrame {
                GeometryReader { geometry in
                    let frame = geometry[rect]
                    VStack {
                        if let selectedSector {
                            Text(selectedSector.title)
                                .foregroundStyle(.secondary)
                            Text("\(String(selectedSector.amount)) \(userCurrencySymbol)")
                                .foregroundStyle(.primary)
                        } else if !data.isEmpty {
                            Text("Total")
                                .foregroundStyle(.secondary)
                            Text("\(getTotalAmount()) \(userCurrencySymbol)")
                                .foregroundStyle(.primary)
                        } else {
                            Text("No data")
                        }
                    }
                    .dynamicTypeSize(.xLarge ... .xLarge)
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .chartAngleSelection(value: $pieChartSelectedAngle)
        .onChange(of: pieChartSelectedAngle) { oldValue, newValue in
            if let newValue {
                let sector = findSelectedSector(value: newValue)
                showImpact()
                if sector != selectedSector {
                    selectedSector = sector
                } else {
                    selectedSector = nil
                }
            }
        }
        .task {
            do {
                userCurrencySymbol = try await dataHandler?.getBaseCurrency().symbol ?? ""
            } catch {
                print(error)
            }
        }
    }
    
    private func getTotalAmount() -> String {
        return String(data.reduce(0, { $0 + $1.amount }))
    }
    
    private func findSelectedSector(value: Int) -> PieChartValue? {
        var accumulatedCount = 0
        let sel = data.first { element in
            accumulatedCount += element.amount
            return value <= accumulatedCount
        }
        return sel
    }
}
