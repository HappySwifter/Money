//
//  MoneyWidgetLiveActivity.swift
//  MoneyWidget
//
//  Created by Artem on 29.07.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MoneyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MoneyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MoneyWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MoneyWidgetAttributes {
    fileprivate static var preview: MoneyWidgetAttributes {
        MoneyWidgetAttributes(name: "World")
    }
}

extension MoneyWidgetAttributes.ContentState {
    fileprivate static var smiley: MoneyWidgetAttributes.ContentState {
        MoneyWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MoneyWidgetAttributes.ContentState {
         MoneyWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MoneyWidgetAttributes.preview) {
   MoneyWidgetLiveActivity()
} contentStates: {
    MoneyWidgetAttributes.ContentState.smiley
    MoneyWidgetAttributes.ContentState.starEyes
}
