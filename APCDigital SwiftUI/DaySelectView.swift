//
//  DaySelectView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/16.
//

import SwiftUI

struct DaySelectView: View {
    @State var selectDay: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    @Environment(DateManagement.self) private var dateManagement
    @Environment(EventManagement.self) private var eventMangement

    var body: some View {
        VStack {
            Text("Select Day")
            DatePicker("",
                       selection: self.$selectDay,
                       displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .environment(\.calendar, Calendar(identifier: .gregorian).withMondayAsFirstDayOfWeek())
                .frame(width: 320)
            HStack {
                Spacer()
                Button(action: {
                    self.dateManagement.setPageStartday(direction: .today, selectday: self.selectDay)
                    self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                                     endDay: self.dateManagement.daysDateComponents[.sunday]!)
                    self.eventMangement.updateCalendars()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Select")
                })
                .padding(8)
                .frame(width: 100)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                }
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Close")
                })
                .padding(8)
                .frame(width: 100)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                }
                Spacer()
            }
        }
        .padding(8)
        .onAppear() {
            if let pagestartday = self.dateManagement.pagestartday {
                self.selectDay = pagestartday
            }
        }
    }
}

#Preview {
    DaySelectView()
}
