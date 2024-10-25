//
//  PencilKitViewRepresentableExample.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/10/25.
//

import Foundation
import SwiftUI
import PencilKit

struct PencilKitViewRepresentableExample: UIViewRepresentable {
    @Binding var pkCanvasView: PKCanvasView
    @Binding var pkToolPicker: PKToolPicker
    
    func makeUIView(context: Context) -> PKCanvasView {
        self.pkCanvasView.isOpaque = false
        self.pkCanvasView.backgroundColor = .clear
        self.pkCanvasView.drawingPolicy = .pencilOnly
        self.pkToolPicker.addObserver(self.pkCanvasView)
        self.pkToolPicker.setVisible(true, forFirstResponder: self.pkCanvasView)
        
        self.pkCanvasView.becomeFirstResponder()
        return self.pkCanvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
    }
    
}
