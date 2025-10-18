//
//  MenuView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/10/17.
//

import SwiftUI

struct MenuView: View {
    @Binding var dispEventEditView: Bool
    @Binding var dispEventListView: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                self.dispEventListView.toggle()
            }, label: {
                Image(systemName: "square.and.arrow.up")
            })
            .buttonStyle(.glass)
            Button(action: {
                self.dispEventEditView.toggle()
            }, label: {
                Image(systemName: "calendar.badge.plus")
                    .font(.title2)
            })
            .buttonStyle(.glass)
        }
        .padding(4)
    }
}

#Preview {
    MenuView(dispEventEditView: .constant(false),
             dispEventListView: .constant(false))
}
