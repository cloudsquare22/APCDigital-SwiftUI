//
//  Item.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/29.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
