//
//  RapPKCanvasView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/23.
//

import Foundation

import UIKit
import PencilKit

class RapPKCanvasView: PKCanvasView {
    
    var onTaskbox: Bool = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print(#function)
        let pKTool = self.tool
        if pKTool is PKEraserTool {
            return
        }
        guard self.onTaskbox == true else {
            return
        }
        print(#function)
        let touch = touches.first
        if let location = touch?.location(in: self), let type = touch?.type, type == .pencil {
            print("type:\(type)")
            print("x:\(location.x) y:\(location.y)")
            self.strokeRectangle(location: location)
        }
    }
    
    func strokeRectangle(location: CGPoint) {
        let size: CGFloat = 8
        let x = location.x - (size / 2)
        let y = location.y - (size / 2)
        let pointArrays = [
            [CGPoint(x: x, y: y),
             CGPoint(x: x + size, y: y),
             CGPoint(x: x + size, y: y + size),
             CGPoint(x: x, y: y + size),
             CGPoint(x: x, y: y)],
        ]
        let pKTool = self.tool
        if let pKInkingTool = pKTool as? PKInkingTool {
            let color = pKInkingTool.color
            let ink = PKInk(.pen, color: color)
            var strokes: [PKStroke] = []

            for points in pointArrays where points.count > 1 {
                let strokePoints = points.enumerated().map { index, point in
                    PKStrokePoint(location: point, timeOffset: 0.1 * TimeInterval(index), size: CGSize(width: 2.4, height: 2.4), opacity: 1, force: 1, azimuth: 0, altitude: 0)
                }

                var startStrokePoint = strokePoints.first!

                for strokePoint in strokePoints {
                    let path = PKStrokePath(controlPoints: [startStrokePoint, strokePoint], creationDate: Date())
                    strokes.append(PKStroke(ink: ink, path: path))
                    startStrokePoint = strokePoint
                }
            }
            print("strokes:\(strokes.count)")
            self.drawing.strokes.append(contentsOf: strokes)
            
            self.undoManager!.registerUndo(withTarget: self, selector: #selector(undoStrocke), object: self.drawing.strokes)
        }
    }
    
    @objc func undoStrocke() {
        for _ in 1...5 {
            self.drawing.strokes.removeLast()
        }
    }
    
}
