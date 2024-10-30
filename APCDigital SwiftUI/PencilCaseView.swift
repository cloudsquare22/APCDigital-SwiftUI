//
//  PencilCaseView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/07.
//

import SwiftUI
import PencilKit

struct PencilCaseView: View {
    @Binding var pkCanvasView: PKCanvasView
    @Binding var pkToolPicker: PKToolPicker
    @State var taskboxColor: Color = .gray
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                HStack {
                    PencilColorButtonView(uiColor: .black, pkCanvasView: self.$pkCanvasView, pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color(hex: 0xD40000)), pkCanvasView: self.$pkCanvasView, pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color(hex: 0x0000E5)), pkCanvasView: self.$pkCanvasView, pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color("Basic Green", bundle: .main)), pkCanvasView: self.$pkCanvasView, pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color(hex: 0x9900E7)), pkCanvasView: self.$pkCanvasView, pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color(hex: 0xED732E)), pkCanvasView: self.$pkCanvasView, pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color(hex: 0x5AC4F7)), pkCanvasView: self.$pkCanvasView, pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
                    PencilColorButtonView(uiColor: UIColor(Color(hex: 0xFF00FF)), pkCanvasView: self.$pkCanvasView, pkToolPicker: self.$pkToolPicker, taskboxColor: self.$taskboxColor)
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
    @Binding var pkToolPicker: PKToolPicker
    @Binding var taskboxColor: Color
    
    func setPKTool() {
        print(#function)
        let pKTool = self.pkCanvasView.tool
        if var pKInkingTool = pKTool as? PKInkingTool {
            print("PKInkingTool")
            pKInkingTool.color = self.uiColor
            self.pkToolPicker.selectedTool = pKInkingTool
//            self.pkToolPicker.selectedToolItem = PKToolPickerInkingItem(type: pKInkingTool.inkType, color: self.uiColor)
            self.pkCanvasView.tool = pKInkingTool
        }
        else {
            print("etc Tool")
        }
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
                   pkToolPicker: .constant(PKToolPicker()))
}
