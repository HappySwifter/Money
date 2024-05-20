//
//  ChartView.swift
//  Money
//
//  Created by Artem on 20.05.2024.
//

import SwiftUI
import Charts

struct PieChartValue: Equatable, Hashable, Identifiable {
    var id: String {
        title
    }
    
    let amount: Int
    let title: String
    let data: [Transaction]
}

struct ChartView: View {
    @State private var pieChartSelectedAngle: Int?
    @Binding var data: [PieChartValue]
    @Binding var selectedSector: PieChartValue?
    
    var body: some View {
        Chart(data, id: \.title) { element in
            SectorMark(
                angle: .value("Expenses", element.amount),
                innerRadius: .ratio(0.6),
                angularInset: 2
            )
            .opacity(selectedSector == nil ? 1.0 : (selectedSector == element ? 1.0 : 0.5))
            .cornerRadius(10)
            .foregroundStyle(by: .value("Name", element.title))
            .annotation(position: .overlay) {
                Text(element.title)
                    .foregroundStyle(Color.white)
            }
        }
        .aspectRatio(1, contentMode: .fit )
        .frame(height: 300)
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                let frame = geometry[chartProxy.plotAreaFrame]
                VStack {
                    if let selectedSector {
                        Text(selectedSector.title)
                            .font(.largeTitle)
                        Text(String(selectedSector.amount))
                            .font(.largeTitle)
                    }
                }
                .position(x: frame.midX, y: frame.midY)
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
