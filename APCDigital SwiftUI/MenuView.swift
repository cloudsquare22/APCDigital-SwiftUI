//
//  MenuView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/10/17.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        HStack {
            Button(action: {
            }, label: {
                Image(systemName: "arrowkeys.up.filled")
            })
            .buttonStyle(.glass)
            Button(action: {
            }, label: {
                Image(systemName: "plus")
            })
            .buttonStyle(.glass)
        }
        .padding(4)
    }
}

#Preview {
    MenuView()
}
