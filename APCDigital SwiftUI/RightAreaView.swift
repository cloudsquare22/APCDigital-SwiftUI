//
//  RightAreaView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/06.
//

import SwiftUI

struct RightAreaView: View {
    @Environment(DateManagement.self) private var dateManagement
    @State var monthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 145, height: 105), day: Date.now)
    @State var nextMonthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 145, height: 105), day: Date.now, selectWeek: false)

    var body: some View {
        ZStack {
            MonthLabelView()
            FromToView()
            MonthlyCalendarViewRepresentable(monthlyCarendarView: self.$monthlyCalendarView)
                .offset(x: 1170, y: 132)
            MonthlyCalendarViewRepresentable(monthlyCarendarView: self.$nextMonthlyCalendarView)
                .offset(x: 1170, y: 237)
            WeekOfYearView()
        }
        .onChange(of: self.dateManagement.pagestartday, { old, new in
            if let day = new {
                self.monthlyCalendarView.update(day: day)
                if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: day) {
                    self.nextMonthlyCalendarView.update(day: nextMonth, selectWeek: false)
                }
            }
        })
    }
}

#Preview {
    RightAreaView()
        .environment(DateManagement())
}
