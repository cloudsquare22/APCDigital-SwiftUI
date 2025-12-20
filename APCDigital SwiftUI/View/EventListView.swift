//
//  EventListView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/10/18.
//

import SwiftUI
import EventKit

struct EventListView: View {
    @Environment(EventManagement.self) private var eventMangement
    @Environment(DateManagement.self) private var dateManagement
    @Environment(\.dismiss) var dismiss
    @Binding var dispEventEditView: Bool
    
    @State private var selectedTab: Int = 0

    fileprivate func viewEvent(_ event: EKEvent) -> HStack<TupleView<(VStack<TupleView<(HStack<TupleView<(some View, _ConditionalContent<Text, Text>)>>, Text)>>, Spacer, some View)>> {
        return HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(self.eventMangement.cgToUIColor(cgColor: event.calendar.cgColor,
                                                                         alpha: 1.0))
                    if event.isAllDay == true {
                        Text("\(event.startDate.formatted(.dateTime.year().month().day()))")
                    }
                    else {
                        Text("\(event.startDate.formatted(.dateTime.year().month().day().hour().minute()))〜\(event.endDate.formatted(.dateTime.hour().minute()))")
                    }
                }
                Text(event.title)
            }
            Spacer()
            Button(action: {
                self.eventMangement.operationEventDatas = []
                let eventData = self.eventMangement.eKEventToEventData(event: event)
                self.eventMangement.operationEventDatas.append(eventData)
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.dispEventEditView.toggle()
                }
            }, label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
            })
            .buttonStyle(.glass)
        }
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: self.$selectedTab) {
                ForEach(WeekDay1stMonday.allCases, id: \.self) { weekDay1stMonday in
                    Tab("\(self.dateManagement.days[weekDay1stMonday]!)", systemImage: "calendar", value: self.dateManagement.days[weekDay1stMonday]!) {
                        List {
                            ForEach(eventMangement.events, id: \.eventIdentifier) { event in
                                if self.isDisp(event: event, targetDay: self.dateManagement.days[weekDay1stMonday]!) == true {
                                    viewEvent(event)
                                }
                            }
                            .onDelete(perform: rowRemove)
                        }
                    }
                }
            }
            .tabViewStyle(.tabBarOnly)
            .navigationTitle("Event List")
            .toolbarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button("Cancel",
                           action: {
                        dismiss()
                    })
                })
                ToolbarItem(placement: .confirmationAction, content: {
                    Button("Add",
                           action: {
                        self.eventMangement.operationEventDatas = []
                        let eventData = self.eventMangement.createEventDataNew()
                        self.eventMangement.operationEventDatas.append(eventData)
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            self.dispEventEditView.toggle()
                        }
                    })
                })
            })
        }
        .onAppear {
            let now = Date.now
            let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
            self.selectedTab = components.day!
        }
    }
    
    func rowRemove(offsets: IndexSet) {
        offsets.forEach { index in
            let ekEvent = self.eventMangement.events[index]
            let eventData = self.eventMangement.eKEventToEventData(event: ekEvent)
            self.eventMangement.removeEventData(eventData: eventData)
        }
    }
    
    func isDisp(event: EKEvent, targetDay: Int) -> Bool {
        var disp = false
        if let calendar = event.calendar, calendar.title == "日本の祝日" {
            disp = false
        }
        else if let calendar = event.calendar, calendar.title == "誕生日" {
            disp = false
        }
        else if let calendar = event.calendar, calendar.type != .calDAV {
            disp = false
        }
        else {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: event.startDate)
            if let day = components.day, targetDay == day {
                disp = true
            }
        }
        return disp
    }
}

#Preview {
    EventListView(dispEventEditView: .constant(false))
}
