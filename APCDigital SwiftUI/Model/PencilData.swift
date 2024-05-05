//
//  PencilData.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/05.
//

import Foundation
import SwiftData

@Model
final class PencilData {
    var year: Int
    var month: Int
    var day: Int
    var data: Data
    
    init(year: Int, month: Int, day: Int, data: Data) {
        self.year = year
        self.month = month
        self.day = day
        self.data = data
    }
}
