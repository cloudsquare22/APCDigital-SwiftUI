//
//  EventViewData.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/03.
//

import Foundation

struct EventViewData {
    var contents: String = ""
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var width: CGFloat = 140.0
    var height: CGFloat = 45.5
    var startSymbolName: String = "circle"
    var startSymbolYAdjust: CGFloat = 0.0
    var endSymbolName: String = "chevron.down"
    var endSymbolYAdjust: CGFloat = -4.0
    var dispTopLine: Bool = true
    var dispBottomLine: Bool = true
}
