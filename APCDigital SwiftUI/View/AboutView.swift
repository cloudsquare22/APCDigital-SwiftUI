//
//  AboutView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/12/23.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image("AboutIcon", bundle: .main)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Rectangle())
                    .cornerRadius(12)
                Text("Version \(version)")
                Text("©️ 2026 cloudsquare.jp")
                .font(.footnote)
                Spacer()
            }
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
