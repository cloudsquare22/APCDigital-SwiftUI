//
//  EventView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/02.
//

import SwiftUI
import EventKit

struct EventsView: View {
    @Environment(EventManagement.self) private var eventMangement

    func cgToUIColor(cgColor: CGColor, alpha: CGFloat = 0.3) -> UIColor {
        return UIColor(red: cgColor.components![0],
                       green: cgColor.components![1],
                       blue: cgColor.components![2],
                       alpha: alpha)
    }

    fileprivate func createEventView(_ event: EKEvent) -> some View {
        let eventViewData = self.eventMangement.eventPosition(event: event)
        return Text(eventViewData.contents)
            .font(Font.system(size: 10.0, weight: .medium, design: .default))
            .padding(EdgeInsets(top: 0.0, leading: 6.0, bottom: 0.0, trailing: 0.0))
            .frame(width: eventViewData.width, 
                   height: eventViewData.height,
                   alignment: .topLeading)
            .overlay(alignment: .topLeading, content: {
                Image(systemName: eventViewData.startSymbolName)
                    .fontWeight(.light)
                    .position(x: 0, y: 0 + eventViewData.startSymbolYAdjust)
                if eventViewData.isMove == false {
                    Image(systemName: eventViewData.endSymbolName)
                        .fontWeight(.light)
                        .position(x: 0, y: eventViewData.height + eventViewData.endSymbolYAdjust)
                }
                else {
                    Image(systemName: eventViewData.endSymbolName)
                        .fontWeight(.light)
                        .position(x: eventViewData.width / 2, y: eventViewData.height + eventViewData.endSymbolYAdjust)
                }
                // 上
                if eventViewData.dispTopLine == true {
                    Path { path in
                            path.addLines([
                                CGPoint(x: 6, y: 0),
                                CGPoint(x: eventViewData.width, y: 0),
                            ])
                         }
                    .stroke(lineWidth: 1)
                }
                if eventViewData.isMove == false {
                    // 左
                    Path { path in
                            path.addLines([
                                CGPoint(x: 0, y: 6),
                                CGPoint(x: 0, y: eventViewData.height),
                            ])
                         }
                    .stroke(lineWidth: 1)
                }
                else {
                    // 真ん中
                    Path { path in
                            path.addLines([
                                CGPoint(x: eventViewData.width / 2, y: 0),
                                CGPoint(x: eventViewData.width / 2, y: eventViewData.height),
                            ])
                         }
                    .stroke(lineWidth: 1)
                }
                // 下
                if eventViewData.dispBottomLine == true {
                    Path { path in
                            path.addLines([
                                CGPoint(x: 0, y: eventViewData.height),
                                CGPoint(x: eventViewData.width, y: eventViewData.height),
                            ])
                         }
                    .stroke(lineWidth: 1)
                }
            })
//            .border(.black, width: 0.8)
            .background(Color(uiColor: self.cgToUIColor(cgColor: event.calendar.cgColor)))
            .offset(x: eventViewData.x,
                    y: eventViewData.y)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(self.eventMangement.mainAreaEvents, id: \.self) { event in
                    createEventView(event)
//                        Rectangle()
//                            .fill(.cyan.opacity(0.1))
//                            .frame(width: 100, height: 100, alignment: .topLeading)
//                            .overlay(content: {
//                                Text("\(event.title!)")
//                                    .offset(x: 0, y: 0)
//                            })
//                            .offset(x: 0, y: 0)
//                    }
                }
            }
        }
        .onAppear() {
            print(self.eventMangement.events.count)
        }
    }
}

#Preview {
    EventsView()
        .environment(EventManagement())
}
