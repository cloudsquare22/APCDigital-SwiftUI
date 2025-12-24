//
//  MenuView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/10/17.
//

import SwiftUI

struct MenuView: View {
    @Environment(EventManagement.self) private var eventMangement
    @Environment(DateManagement.self) private var dateManagement
    @Binding var dispEventEditView: Bool
    @Binding var dispEventListView: Bool
    @Binding var dispExportView: Bool
    @Binding var dispDaySelectView: Bool
    @Binding var dispAboutView: Bool

    var body: some View {
        HStack {
            Button(action: {
                self.dateManagement.setPageStartday(direction: .back)
                self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                                 endDay: self.dateManagement.daysDateComponents[.sunday]!)
                self.eventMangement.updateCalendars()
            }, label: {
                Image(systemName: "arrowtriangle.backward")
                    .font(.title2)
                    .frame(width: 24, height: 24, alignment: .center)
            })
            .buttonStyle(.glass)
            Menu {
                Button(action: {
                    self.dispDaySelectView.toggle()
                }, label: {
                    Label("Select day", systemImage: "calendar.day.timeline.leading")
                })
                .buttonStyle(.glass)
                Button(action: {
                    self.dispEventListView.toggle()
                }, label: {
                    Label("Event List", systemImage: "list.bullet")
                })
                .buttonStyle(.glass)
                Button(action: {
                    self.eventMangement.operationEventDatas = []
                    let eventData = self.eventMangement.createEventDataNew()
                    self.eventMangement.operationEventDatas.append(eventData)
                    self.dispEventEditView.toggle()
                }, label: {
                    Label("add Evnet", systemImage: "calendar.badge.plus")
                })
                .buttonStyle(.glass)

            } label: {
                Image(systemName: "calendar")
                    .font(.title2)
                    .frame(width: 24, height: 24, alignment: .center)
            }
            .buttonStyle(.glass)
            Button(action: {
                self.dateManagement.setPageStartday(direction: .today)
                self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                                 endDay: self.dateManagement.daysDateComponents[.sunday]!)
                self.eventMangement.updateCalendars()
            }, label: {
                Image(systemName: "return")
                    .font(.title2)
                    .frame(width: 24, height: 24, alignment: .center)
            })
            .buttonStyle(.glass)
            Menu {
                Button(action: {
                    self.dispExportView.toggle()
                }, label: {
                    Label("Export", systemImage: "square.and.arrow.up.on.square")
                })
                .buttonStyle(.glass)
                Button(action: {
                }, label: {
                    Label("Setting", systemImage: "gearshape")
                })
                .buttonStyle(.glass)
                Button(action: {
                    self.dispAboutView.toggle()
                }, label: {
                    Label("About", systemImage: "info")
                })
                .buttonStyle(.glass)
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .frame(width: 24, height: 24, alignment: .center)
            }
            .buttonStyle(.glass)
            Button(action: {
                self.dateManagement.setPageStartday(direction: .next)
                self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                                 endDay: self.dateManagement.daysDateComponents[.sunday]!)
                self.eventMangement.updateCalendars()
            }, label: {
                Image(systemName: "arrowtriangle.forward")
                    .font(.title2)
                    .frame(width: 24, height: 24, alignment: .center)
            })
            .buttonStyle(.glass)
        }
        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
    }
}

#Preview {
    MenuView(dispEventEditView: .constant(false),
             dispEventListView: .constant(false),
             dispExportView: .constant(false),
             dispDaySelectView: .constant(false),
             dispAboutView: .constant(false))
}
