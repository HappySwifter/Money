////
////  TransactionPeriodType.swift
////  Money
////
////  Created by Artem on 20.05.2024.
////
//
//import Foundation
//
//enum TransactionPeriodType {
//    case day(value: Date)
//    case month(value: Date)
//    case year(value: Date)
//    
//    var startDate: Date {
//        switch self {
//        case .day(let value):
//            return Calendar.current.startOfDay(for: value)
//        case .month(let value):
//            let comp = Calendar.current.dateComponents([.year, .month], from: value)
//            return Calendar.current.date(from: comp)!
//        case .year(let value):
//            let comp = Calendar.current.dateComponents([.year], from: value)
//            return Calendar.current.date(from: comp)!
//        }
//    }
//    
//    var endDate: Date {
//        let component: Calendar.Component
//        switch self {
//        case .day: component = .day
//        case .month: component = .month
//        case .year: component = .year
//        }
//        return Calendar.current.date(byAdding: component, value: 1, to: startDate)!
//    }
//}
