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
    
    @State var uiColor: UIColor = .black
    @State var inkType: PKInkingTool.InkType = .monoline
    @State var eraser: Bool = false

    func setPKTool() {
        print(#function)
        if eraser == true {
            print("set PKEraserTool:\(self.eraser)")
            self.pkCanvasView.tool = PKEraserTool(.vector)
        }
        else {
            self.pkCanvasView.tool = PKInkingTool(self.inkType,
                                                  color: self.uiColor,
                                                  width: self.inkType.minWidth())
            print("set PKInkingTool")
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                HStack {
                    Button(action: {
                        self.uiColor = .black
                    }, label: {
                        Image(systemName: "pencil.tip.crop.circle")
                            .font(Font.system(size: 32.0, weight: .regular))
                            .foregroundStyle(.black)
                    })
                    Button(action: {
                        self.uiColor = .red
                    }, label: {
                        Image(systemName: "pencil.tip.crop.circle")
                            .font(Font.system(size: 32.0, weight: .regular))
                            .foregroundStyle(.red)
                    })
                    Button(action: {
                        self.eraser.toggle()
                    }, label: {
                        Image(systemName: "eraser")
                            .font(Font.system(size: 32.0, weight: .regular))
                            .foregroundStyle(.black)
                            .background(.white.opacity(0.1))
                    })
                }
                .onChange(of: self.uiColor, { old, new in
                    self.setPKTool()
                })
                .onChange(of: self.inkType, { old, new in
                    self.setPKTool()
                })
                .onChange(of: self.eraser, { old, new in
                    self.setPKTool()
                })
                .offset(x: 550,
                        y: 8)
            }
        }
    }
}

#Preview {
    PencilCaseView(pkCanvasView: .constant(PKCanvasView(frame: .zero)))
}
