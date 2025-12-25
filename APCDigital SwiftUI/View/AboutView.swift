//
//  AboutView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/12/23.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationTitle("About")
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
    AboutView()
}
