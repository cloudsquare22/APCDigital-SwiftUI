//
//  MenuView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/10/17.
//

import SwiftUI

struct MenuView: View {
    @Environment(EventManagement.self) private var eventMangement
    @Binding var dispEventEditView: Bool
    @Binding var dispEventListView: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                self.dispEventListView.toggle()
            }, label: {
                Image(systemName: "list.bullet")
                    .font(.title2)
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
            })
            .buttonStyle(.glass)
            Button(action: {
            }, label: {
                Image(systemName: "square.and.arrow.up.on.square")
                    .font(.title2)
            })
            .buttonStyle(.glass)
        }
        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
    }
}

#Preview {
    MenuView(dispEventEditView: .constant(false),
             dispEventListView: .constant(false))
}
