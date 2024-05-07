//
//  PencilKitViewRepresentable.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import Foundation
import SwiftUI
import PencilKit

struct PencilKitViewRepresentable: UIViewRepresentable {
    @Binding var pkCanvasView: PKCanvasView
    @Binding var pkToolPicker: PKToolPicker
    
    func makeUIView(context: Context) -> PKCanvasView {
        self.pkCanvasView.isOpaque = false
        self.pkCanvasView.backgroundColor = .clear
        self.pkCanvasView.drawingPolicy = .pencilOnly
//        self.pkCanvasView.tool = PKInkingTool(.monoline,
//                                              color: .black,
//                                              width: PKInkingTool.InkType.monoline.minWidth())
        self.pkToolPicker.addObserver(self.pkCanvasView)
        self.pkToolPicker.setVisible(true, forFirstResponder: self.pkCanvasView)
        self.pkCanvasView.becomeFirstResponder()
        return pkCanvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
    }
}
