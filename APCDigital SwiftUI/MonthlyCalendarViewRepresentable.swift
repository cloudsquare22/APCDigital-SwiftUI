//
//  MonthlyCalendarViewRepresentable.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/06.
//

import Foundation
import SwiftUI

struct MonthlyCalendarViewRepresentable: UIViewRepresentable {
    @Binding var monthlyCarendarView: MonthlyCalendarView
    
    func makeUIView(context: Context) -> UIView {
        return monthlyCarendarView.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
