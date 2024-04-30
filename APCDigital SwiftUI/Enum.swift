//
//  Enum.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import Foundation

enum WeekDay1stMonday: Int, CaseIterable {
    case monday = 0
    case tuesday = 1
    case wednesday = 2
    case thursday = 3
    case friday = 4
    case saturday = 5
    case sunday = 6
}

enum PageMondayDirection {
    case today
    case next
    case back
}

enum SwipeType: Int {
    case none
    case up
    case down
    case left
    case right
}
