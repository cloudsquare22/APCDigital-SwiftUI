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
    @Environment(EventManagement.self) private var eventMangement

    @State var pkCanvasView: PKCanvasView = PKCanvasView(frame: .zero)
    @State var pkToolPicker: PKToolPicker = PKToolPicker()

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Image("aptemplate", bundle: .main)
                    .resizable()
                    .scaledToFit()
                DayTopAreaView()
                MonthLabelView()
                EventsView()
                PencilKitViewRepresentable(pkCanvasView: self.$pkCanvasView,
                                           pkToolPicker: self.$pkToolPicker)
                .gesture(DragGesture(coordinateSpace: .global)
                    .onEnded({ value in
                        let swipeType = self.swipeType(startLocation: value.startLocation,
                                                       location: value.location)
                        self.changePage(swipeType: swipeType)
                    })
                )
//                Text("1234567890")
//                    .font(Font.system(size: 48))
//                    .foregroundStyle(.blue)
//                    .border(.blue, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
//                    .offset(x: 0, y: 0)
//                Text("1234567890")
//                    .font(Font.system(size: 48))
//                    .foregroundStyle(.red)
//                    .border(.blue, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
//                    .position(x: 0, y: 0)
            }
        }
        .onAppear() {
            print(Device.getDevie())
            self.dateManagement.setPageStartday(direction: .today)
            self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                             endDay: self.dateManagement.daysDateComponents[.sunday]!)
            self.eventMangement.updateCalendars()
        }
    }
    
    func changePage(swipeType: SwipeType) {
        print("SwipeType:\(swipeType)")
        switch swipeType {
        case .left:
            self.dateManagement.setPageStartday(direction: .next)
            self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                             endDay: self.dateManagement.daysDateComponents[.sunday]!)
            self.eventMangement.updateCalendars()

        case .right:
            self.dateManagement.setPageStartday(direction: .back)
            self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                             endDay: self.dateManagement.daysDateComponents[.sunday]!)
            self.eventMangement.updateCalendars()
        case .up:
            break;
        case .down:
            self.dateManagement.setPageStartday(direction: .today, selectday: Date.now)
            self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                             endDay: self.dateManagement.daysDateComponents[.sunday]!)
            self.eventMangement.updateCalendars()
        case .none:
            break;
        }
    }

    func swipeType(startLocation: CGPoint, location: CGPoint) -> SwipeType {
        var swipeType: SwipeType = .none
//        print("startLocation:\(startLocation)")
//        print("location     :\(location)")
        let b = startLocation.y - location.y
        let c = location.x - startLocation.x
        let degree = atan2(b, c) * 180 / Double.pi
//        print("\(#function) b:\(b)")
//        print("\(#function) c:\(c)")
//        print("\(#function)  :\(degree)")
        if -30.0 <= degree && degree <= 30 {
            swipeType = .right
        }
        else if 60.0 <= degree && degree <= 120 {
            swipeType = .up
        }
        else if (150.0 <= degree && degree <= 180.0) ||
                    (-180 <= degree && degree <= -150.0) {
            swipeType = .left
        }
        else if -120.0 <= degree && degree <= -60.0 {
            swipeType = .down
        }
        return swipeType
    }
}

#Preview {
    MainView()
        .environment(DateManagement())
        .environment(EventManagement())
}
