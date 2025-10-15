//
//  PencilCaseView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/07.
//

import SwiftUI
import PencilKit
import PaperKit

struct PencilCaseView: View {
    @Binding var pkCanvasView: PKCanvasView
    @Binding var pkToolPicker: PKToolPicker
    @Binding var paperMarkupViewController: PaperMarkupViewController?
    @State var taskboxColor: Color = .gray
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                HStack {
                    PencilColorButtonView(uiColor: .black, pkCanvasView: self.$pkCanvasView, paperMarkupViewController: self.$paperMarkupViewController, pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color(hex: 0xD40000)), pkCanvasView: self.$pkCanvasView, paperMarkupViewController: self.$paperMarkupViewController,pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color(hex: 0x0000E5)), pkCanvasView: self.$pkCanvasView, paperMarkupViewController: self.$paperMarkupViewController,pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color("Basic Green", bundle: .main)), pkCanvasView: self.$pkCanvasView, paperMarkupViewController: self.$paperMarkupViewController,pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color(hex: 0x9900E7)), pkCanvasView: self.$pkCanvasView, paperMarkupViewController: self.$paperMarkupViewController,pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color(hex: 0xED732E)), pkCanvasView: self.$pkCanvasView, paperMarkupViewController: self.$paperMarkupViewController,pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color(hex: 0x5AC4F7)), pkCanvasView: self.$pkCanvasView, paperMarkupViewController: self.$paperMarkupViewController,pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color(hex: 0xFF00FF)), pkCanvasView: self.$pkCanvasView, paperMarkupViewController: self.$paperMarkupViewController,pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    Button(action: {
                        if let rapPKCanvasView = self.pkCanvasView as? RapPKCanvasView, let pKInkingTool = rapPKCanvasView.tool as? PKInkingTool {
                            rapPKCanvasView.onTaskbox.toggle()
                            if rapPKCanvasView.onTaskbox == true {
                                self.taskboxColor = Color(uiColor: pKInkingTool.color)
                            }
                            else {
                                self.taskboxColor = .gray
                            }
                        }
                    }, label: {
                        Image(systemName: "square.and.pencil")
                            .font(Font.system(size: 30.0, weight: .regular))
                            .foregroundStyle(self.taskboxColor)
                    })
                }
            }
        }
    }
}

struct PencilColorButtonView: View {
    let uiColor: UIColor
    @Binding var pkCanvasView: PKCanvasView
    @Binding var paperMarkupViewController: PaperMarkupViewController?
    @Binding var pkToolPicker: PKToolPicker
    @Binding var taskboxColor: Color
    
    func setPKTool() {
        print(#function)
        if var tool = self.paperMarkupViewController?.drawingTool as? PKInkingTool {
            tool.color = .red
            tool.inkType = .pen
            self.pkToolPicker.selectedToolItem = PKToolPickerInkingItem(type: .pen, color: .red)
            self.pkToolPicker.removeObserver(self.paperMarkupViewController!)
            self.pkToolPicker.addObserver(self.paperMarkupViewController!)
            self.paperMarkupViewController!.pencilKitResponderState.activeToolPicker = self.pkToolPicker
            self.paperMarkupViewController!.pencilKitResponderState.toolPickerVisibility = .visible

            self.paperMarkupViewController!.drawingTool = tool
        }
        
//        if var pKInkingTool = pKTool as? PKInkingTool {
//            print("PKInkingTool")
//            pKInkingTool.color = .red
//            pKInkingTool.inkType = .pen
//            
//            print("*** \(pKInkingTool.inkType)")
//            print("*** \(pKInkingTool.color)")
//            print("*** \(self.pkToolPicker.selectedToolItem.tool.debugDescription)")
//            print("*** \(self.pkToolPicker.selectedToolItemIdentifier)")
//            self.pkToolPicker.selectedToolItem = PKToolPickerInkingItem(type: .pen, color: .red)
//            print("*** \(PKToolPickerInkingItem(type: .pen, color: .red).tool.debugDescription)")
//            print("*** \(self.pkToolPicker.selectedToolItem.tool.debugDescription)")
//            print("*** \(self.pkToolPicker.selectedToolItemIdentifier)")
////            self.pkToolPicker.selectedToolItem = PKToolPickerInkingItem(type: pKInkingTool.inkType, color: self.uiColor)
//            self.pkCanvasView.tool = pKInkingTool
//        }
//        else {
//            print("etc Tool")
//        }
        if self.taskboxColor != .gray {
            self.taskboxColor = Color(uiColor: self.uiColor)
        }
    }

    var body: some View {
        Button(action: {
            self.setPKTool()
        }, label: {
            Image(systemName: "pencil.tip.crop.circle")
                .font(Font.system(size: 32.0, weight: .regular))
                .foregroundStyle(Color(uiColor: self.uiColor))
        })
    }
}


#Preview {
    PencilCaseView(pkCanvasView: .constant(PKCanvasView(frame: .zero)),
                   pkToolPicker: .constant(PKToolPicker()),
                   paperMarkupViewController: .constant(PaperMarkupViewController(supportedFeatureSet: .latest)))
}
