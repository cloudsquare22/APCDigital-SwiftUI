//
//  PencilCaseView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/11/03.
//

import SwiftUI
import PencilKit
import PaperKit

struct PencilCaseView: View {
    @Binding var pkToolPicker: PKToolPicker
    @Binding var paperMarkupViewController: PaperMarkupViewController?

    var body: some View {
        HStack {
            Image(systemName: "pencil.tip.crop.circle")
                            .foregroundStyle(Color(uiColor: UIColor(Color(hex: 0xD40000))))
                            .font(.title)
                            .buttonStyle(.glass)
                            .onTapGesture {
                                print("taptaptap")
                            }
            Image(systemName: "pencil.tip.crop.circle")
                            .foregroundStyle(Color(uiColor: UIColor(Color("Basic Green", bundle: .main))))
                            .font(.title)
                            .buttonStyle(.glass)
                            .onTapGesture {
                                if let controller = self.paperMarkupViewController,
                                   let item = self.pkToolPicker.selectedToolItem.tool as? PKInkingTool {
                                    print("taptaptap")
                                    self.pkToolPicker.removeObserver(controller)
                                    self.pkToolPicker.selectedToolItem = PKToolPickerInkingItem(type: item.inkType,
                                                                                                color: UIColor(Color("Basic Green", bundle: .main)),
                                                                                                width: item.width)
                                    self.pkToolPicker.addObserver(controller)
                                    controller.pencilKitResponderState.activeToolPicker = self.pkToolPicker
                                    controller.pencilKitResponderState.toolPickerVisibility = .visible
                                }
                            }
        }
        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
    }
}

#Preview {
//    PencilCaseView()
}
