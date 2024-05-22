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
    
    @State var uiColor: UIColor = .black

    func setPKTool() {
        print(#function)
        let pKTool = self.pkCanvasView.tool
        if var pKInkingTool = pKTool as? PKInkingTool {
            print("PKInkingTool")
            pKInkingTool.color = uiColor
            self.pkToolPicker.selectedTool = pKInkingTool
            self.pkCanvasView.tool = pKInkingTool
        }
        else {
            print("etc Tool")
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
                        self.uiColor = UIColor(Color(hex: 0xD40000))
                    }, label: {
                        Image(systemName: "pencil.tip.crop.circle")
                            .font(Font.system(size: 32.0, weight: .regular))
                            .foregroundStyle(Color(hex: 0xD40000))
                    })
                    Button(action: {
                        self.uiColor = UIColor(Color(hex: 0x0000E5))
                    }, label: {
                        Image(systemName: "pencil.tip.crop.circle")
                            .font(Font.system(size: 32.0, weight: .regular))
                            .foregroundStyle(Color(hex: 0x0000E5))
                    })
                    Button(action: {
                        self.uiColor = UIColor(Color("Basic Green", bundle: .main))
                    }, label: {
                        Image(systemName: "pencil.tip.crop.circle")
                            .font(Font.system(size: 32.0, weight: .regular))
                            .foregroundStyle(Color("Basic Green", bundle: .main))
                    })
                    Button(action: {
                        self.uiColor = UIColor(Color(hex: 0x9900E7))
                    }, label: {
                        Image(systemName: "pencil.tip.crop.circle")
                            .font(Font.system(size: 32.0, weight: .regular))
                            .foregroundStyle(Color(hex: 0x9900E7))
                    })
                    Button(action: {
                        self.uiColor = UIColor(Color(hex: 0xED732E))
                    }, label: {
                        Image(systemName: "pencil.tip.crop.circle")
                            .font(Font.system(size: 32.0, weight: .regular))
                            .foregroundStyle(Color(hex: 0xED732E))
                    })
                    Button(action: {
                        self.uiColor = UIColor(Color(hex: 0x5AC4F7))
                    }, label: {
                        Image(systemName: "pencil.tip.crop.circle")
                            .font(Font.system(size: 32.0, weight: .regular))
                            .foregroundStyle(Color(hex: 0x5AC4F7))
                    })
                    Button(action: {
                        self.uiColor = UIColor(Color(hex: 0xFF00FF))
                    }, label: {
                        Image(systemName: "pencil.tip.crop.circle")
                            .font(Font.system(size: 32.0, weight: .regular))
                            .foregroundStyle(Color(hex: 0xFF00FF))
                    })
                }
                .onChange(of: self.uiColor, { old, new in
                    self.setPKTool()
                })
            }
        }
    }
}

#Preview {
    PencilCaseView(pkCanvasView: .constant(PKCanvasView(frame: .zero)),
                   pkToolPicker: .constant(PKToolPicker()))
}
