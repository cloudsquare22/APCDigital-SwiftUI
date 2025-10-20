//
//  RemainingLebelView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/06.
//

import SwiftUI

struct RemainingLebelView: View {
    @Environment(DateManagement.self) private var dateManagement

    fileprivate func createRemainingLebelView(_ weekDay1stMonday: WeekDay1stMonday) -> some View {
        let labelViewData = self.dateManagement.createRemainingLebelViewData(weekDay1stMonday: weekDay1stMonday)
        return Text(labelViewData.contents)
            .foregroundStyle(Color("Basic Green", bundle: .main))
            .font(Font.system(size: 10.0, weight: .semibold))
            .offset(x: labelViewData.x,
                    y: labelViewData.y)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(WeekDay1stMonday.allCases, id: \.self) { weekDay1stMonday in
                    self.createRemainingLebelView(weekDay1stMonday)
                }
            }
        }
    }
}

#Preview {
    RemainingLebelView()
        .environment(DateManagement())
}
