//
//  MonthLabelView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import SwiftUI

struct MonthLabelView: View {
    @Environment(DateManagement.self) private var dateManagement

    fileprivate func createMonthLebelView() -> some View {
        let labelViewData = self.dateManagement.createMonthLebelViewData()
        return Text(labelViewData.contents)
            .foregroundStyle(Color("Basic Green", bundle: .main))
            .font(Font.system(size: 48.0, weight: .semibold))
            .position(x: labelViewData.x,
                      y: labelViewData.y)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                self.createMonthLebelView()
            }
        }
    }
}

#Preview {
    MonthLabelView()
        .environment(DateManagement())
}
