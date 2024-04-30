//
//  MainView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import SwiftUI
import PencilKit

struct MainView: View {
    @Environment(DateManagement.self) private var dateManagement

    @State var pkCanvasView: PKCanvasView = PKCanvasView(frame: .zero)
    @State var pkToolPicker: PKToolPicker = PKToolPicker()

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Image("aptemplate", bundle: .main)
                    .resizable()
                    .scaledToFit()
                DayLabelsView()
                MonthLabelView()
                PencilKitViewRepresentable(pkCanvasView: self.$pkCanvasView,
                                           pkToolPicker: self.$pkToolPicker)
                Text("Offset")
                    .font(Font.system(size: 48))
                    .foregroundStyle(.blue)
                    .border(.blue, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .offset(x: 0, y: 0)
            }
        }
        .onAppear() {
            print(Device.getDevie())
            self.dateManagement.setPageStartday(direction: .today)
        }
    }
}

#Preview {
    MainView()
        .environment(DateManagement())
}
