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
            Button(action: {
                self.dispEventListView.toggle()
            }, label: {
                Image(systemName: "list.bullet")
                    .font(.title2)
                    .frame(width: 24, height: 24, alignment: .center)
            })
            .buttonStyle(.glass)
            Button(action: {
                self.eventMangement.operationEventDatas = []
                let eventData = self.eventMangement.createEventDataNew()
                self.eventMangement.operationEventDatas.append(eventData)
                self.dispEventEditView.toggle()
            }, label: {
                Image(systemName: "calendar.badge.plus")
                    .font(.title2)
                    .frame(width: 24, height: 24, alignment: .center)
            })
            .buttonStyle(.glass)
            Button(action: {
                self.dispExportView.toggle()
            }, label: {
                Image(systemName: "square.and.arrow.up.on.square")
                    .font(.title2)
                    .frame(width: 24, height: 24, alignment: .center)
            })
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
             dispExportView: .constant(false))
}
