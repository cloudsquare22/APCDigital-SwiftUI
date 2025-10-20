//
//  WeekOfYearView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/06.
//

import SwiftUI

struct WeekOfYearView: View {
    @Environment(DateManagement.self) private var dateManagement

    fileprivate func createWeekOfYearView() -> some View {
        let labelViewData = self.dateManagement.createWeekOfYearViewData()
        return Text(labelViewData.contents)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color("Basic Green", bundle: .main))
            .font(Font.system(size: 13.0, weight: .regular))
            .position(x: labelViewData.x,
                      y: labelViewData.y)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                self.createWeekOfYearView()
            }
        }
    }
}

#Preview {
    WeekOfYearView()
        .environment(DateManagement())
}
