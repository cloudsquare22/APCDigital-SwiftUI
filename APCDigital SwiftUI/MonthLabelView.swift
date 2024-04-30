//
//  MonthLabelView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import SwiftUI

struct MonthLabelView: View {
    @Environment(DateManagement.self) private var dateManagement

    var body: some View {
        if let nextMonth = self.dateManagement.nextmonth {
            Text("\(self.dateManagement.month)/\(nextMonth)")
                .foregroundStyle(Color("Basic Green", bundle: .main))
                .font(Font.system(size: 48.0, weight: .semibold))
                .position(x: self.dateManagement.getMonthLebelPosition().x,
                          y: self.dateManagement.getMonthLebelPosition().y)
        }
        else {
            Text("\(self.dateManagement.month)")
                .foregroundStyle(Color("Basic Green", bundle: .main))
                .font(Font.system(size: 48.0, weight: .semibold))
                .position(x: self.dateManagement.getMonthLebelPosition().x,
                          y: self.dateManagement.getMonthLebelPosition().y)
        }
    }
}

#Preview {
    MonthLabelView()
        .environment(DateManagement())
}
