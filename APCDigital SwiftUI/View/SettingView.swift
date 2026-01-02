//
//  SettingView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2026/01/01.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
