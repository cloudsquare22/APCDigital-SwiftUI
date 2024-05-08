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
    
    @Binding var point: CGPoint
    
    func makeUIView(context: Context) -> PKCanvasView {
        self.pkCanvasView.isOpaque = false
        self.pkCanvasView.backgroundColor = .clear
        self.pkCanvasView.drawingPolicy = .pencilOnly
        //        self.pkCanvasView.tool = PKInkingTool(.monoline,
        //                                              color: .black,
        //                                              width: PKInkingTool.InkType.monoline.minWidth())
        self.pkToolPicker.addObserver(self.pkCanvasView)
        self.pkToolPicker.setVisible(true, forFirstResponder: self.pkCanvasView)
        
        let longpress = UILongPressGestureRecognizer(target: context.coordinator,
                                                     action: #selector(Coordinator.longTapped(_:)))
        longpress.minimumPressDuration = 1.0
        pkCanvasView.addGestureRecognizer(longpress)
        
        self.pkCanvasView.becomeFirstResponder()
        return pkCanvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
    }
    
    func makeCoordinator() -> PencilKitViewRepresentable.Coordinator {
       Coordinator(point: $point)
    }
    
    class Coordinator: NSObject {
       @Binding var point: CGPoint

       init(point: Binding<CGPoint>) {
           self._point = point
       }

       @objc func longTapped(_ sender: UILongPressGestureRecognizer) {
           guard sender.state == UIGestureRecognizer.State.began else {
               return
           }
           point = sender.location(in: sender.view)
//           print("#### \(point)")
       }
    }
}
