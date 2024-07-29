//
//  MoneyWidgetBundle.swift
//  MoneyWidget
//
//  Created by Artem on 29.07.2024.
//

import WidgetKit
import SwiftUI

@main
struct MoneyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MoneyWidget()
        MoneyWidgetLiveActivity()
    }
}
