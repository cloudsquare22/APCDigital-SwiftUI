//
//  MainViewExample.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/10/25.
//

import SwiftUI
import PencilKit

struct MainViewExample: View {
    @State var pkCanvasView: PKCanvasView = RapPKCanvasView(frame: .zero)
    @State var pkToolPicker: PKToolPicker = PKToolPicker()

    var body: some View {
        PencilKitViewRepresentableExample(pkCanvasView: self.$pkCanvasView,
                                   pkToolPicker: self.$pkToolPicker)
    }
}

#Preview {
    MainViewExample()
}
