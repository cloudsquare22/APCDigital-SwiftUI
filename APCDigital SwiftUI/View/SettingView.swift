//
//  SettingView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2026/01/01.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @State var moveSymbols: String = ""
    @State var eventBackgroundColor: Bool = true

    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Label("Move symbols", systemImage: "car")
                    Spacer()
                    TextField("Move symbols", text: self.$moveSymbols)
                        .textFieldStyle(.roundedBorder)
                }
                .alignmentGuide(.listRowSeparatorLeading, computeValue: { _ in
                        0
                    })
                HStack {
                    Toggle("Evnet Background Color",
                           systemImage: self.eventBackgroundColor == true ? "paintbrush.fill" : "paintbrush",
                           isOn: self.$eventBackgroundColor)
                }
                .alignmentGuide(.listRowSeparatorLeading, computeValue: { _ in
                        0
                    })
            }
            
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button("Cancel",
                           action: {
                        dismiss()
                    })
                })
            })
        }
    }
}

#Preview {
    SettingView()
}
