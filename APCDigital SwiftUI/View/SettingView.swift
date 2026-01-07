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

    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("Move Symbols")
                    Spacer()
                    TextField("Move symbols", text: self.$moveSymbols)
                        .textFieldStyle(.roundedBorder)
                }
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
