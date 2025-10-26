//
//  CaptureView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/10/24.
//

import SwiftUI
import EventKit

struct CaptureView: View {
    let dateManagement: DateManagement
    let eventManagement: EventManagement
    let size: CGSize
    let monthlyCalendarView: MonthlyCalendarView
    let monthlyCalendarViewImage: UIImage
    let nextMonthlyCalendarView: MonthlyCalendarView
    let nextMonthlyCalendarViewImage: UIImage
    let paperMarkupImage: UIImage

    var body: some View {
//        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Image("aptemplate", bundle: .main)
                    .resizable()
                    .scaledToFit()
                    .position(x: self.size.width / 2, y: self.size.height / 2)
                CaptureDDayTopAreaView(dateManagement: self.dateManagement,
                                       eventManagement: self.eventManagement,
                                       size: self.size)
                // Right Area
                Group {
                    CaptureMonthLabelView(dateManagement: self.dateManagement)
                    CaptureFromToView(dateManagement: self.dateManagement)
                    CaptureWeekOfYearView(dateManagement: self.dateManagement)
                }

                CaptureEventsView(eventMangement: self.eventManagement)
                
//                Image(uiImage: self.paperMarkupImage)

                // Right Area at the very top
                Group {
                    Image(uiImage: self.monthlyCalendarViewImage)
                        .frame(width: 145, height: 105)
                        .offset(x: self.monthlyCalendarView.getOffset().x,
                                y: self.monthlyCalendarView.getOffset().y)
                    Image(uiImage: self.nextMonthlyCalendarViewImage)
                        .frame(width: 145, height: 105)
                        .offset(x: self.nextMonthlyCalendarView.getOffset().x,
                                y: self.nextMonthlyCalendarView.getOffset().y + self.nextMonthlyCalendarView.MONTHLY_CALENDAR_HEIGHTMAX)
                }
            }
            .background(.white)
            .frame(width: self.size.width, height: self.size.height)

//        }
    }
}

#Preview {
//    CaptureView()
}

struct CaptureDDayTopAreaView: View {
    let dateManagement: DateManagement
    let eventManagement: EventManagement
    let size: CGSize

    var body: some View {
        CaptureDayLabelView(dateManagement: self.dateManagement)
        CaptureRemainingLebelView(dateManagement: self.dateManagement)
        CaptureHolidayLabelView(eventMangement: self.eventManagement)
        CaptureEventsAllDayView(eventMangement: self.eventManagement)
    }
}

struct CaptureDayLabelView: View {
    let dateManagement: DateManagement

    fileprivate func createDayLebelView(_ weekDay1stMonday: WeekDay1stMonday) -> some View {
        let labelViewData = self.dateManagement.createDayLebelViewData(weekDay1stMonday: weekDay1stMonday)
        return Text(labelViewData.contents)
            .foregroundStyle(Color("Basic Green", bundle: .main))
            .font(Font.system(size: 24.0, weight: .semibold))
            .offset(x: labelViewData.x,
                    y: labelViewData.y)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(WeekDay1stMonday.allCases, id: \.self) { weekDay1stMonday in
                self.createDayLebelView(weekDay1stMonday)
            }
        }
    }
}

struct CaptureRemainingLebelView: View {
    let dateManagement: DateManagement

    fileprivate func createRemainingLebelView(_ weekDay1stMonday: WeekDay1stMonday) -> some View {
        let labelViewData = self.dateManagement.createRemainingLebelViewData(weekDay1stMonday: weekDay1stMonday)
        return Text(labelViewData.contents)
            .foregroundStyle(Color("Basic Green", bundle: .main))
            .font(Font.system(size: 10.0, weight: .semibold))
            .offset(x: labelViewData.x,
                    y: labelViewData.y)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(WeekDay1stMonday.allCases, id: \.self) { weekDay1stMonday in
                self.createRemainingLebelView(weekDay1stMonday)
            }
        }
    }
}

struct CaptureHolidayLabelView: View {
    let eventMangement: EventManagement

    fileprivate func createHolidayLabelView(_ weekDay1stMonday: WeekDay1stMonday) -> some View {
        let eventViewData = self.eventMangement.createHolidayViewData(weekDay1stMonday: weekDay1stMonday)
        return HStack {
            Spacer()
            Text(eventViewData.contents)
                .foregroundStyle(Color("Basic Green", bundle: .main))
                .font(Font.system(size: 10.0, weight: .semibold, design: .default))
        }
            .frame(width: eventViewData.width,
                   alignment: .topLeading)
            .offset(x: eventViewData.x,
                    y: eventViewData.y)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(WeekDay1stMonday.allCases, id: \.self) { weekDay1stMonday in
                self.createHolidayLabelView(weekDay1stMonday)
            }
        }
    }
}

struct CaptureEventsAllDayView: View {
    let eventMangement: EventManagement

    fileprivate func createEventAllDayView(_ weekDay1stMonday: WeekDay1stMonday) -> some View {
        let eventViewData = self.eventMangement.createAllDayEventViewData(weekDay1stMonday: weekDay1stMonday)
        return Text(eventViewData.contents)
            .lineLimit(5)
            .font(Font.system(size: 9.6, weight: .medium, design: .default))
            .frame(width: eventViewData.width,
                   alignment: .topLeading)
            .offset(x: eventViewData.x,
                    y: eventViewData.y)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(WeekDay1stMonday.allCases, id: \.self) { weekDay1stMonday in
                createEventAllDayView(weekDay1stMonday)
            }
        }
    }
}

struct CaptureMonthLabelView: View {
    let dateManagement: DateManagement

    fileprivate func createMonthLebelView() -> some View {
        let labelViewData = self.dateManagement.createMonthLebelViewData()
        return Text(labelViewData.contents)
            .foregroundStyle(Color("Basic Green", bundle: .main))
            .font(Font.system(size: 48.0, weight: .semibold))
            .position(x: labelViewData.x,
                      y: labelViewData.y)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            self.createMonthLebelView()
        }
    }
}

struct CaptureFromToView: View {
    let dateManagement: DateManagement

    fileprivate func createFromToView() -> some View {
        let labelViewData = self.dateManagement.createFromToLebelViewData()
        return Text(labelViewData.contents)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color("Basic Green", bundle: .main))
            .font(Font.system(size: 15.0, weight: .regular))
            .position(x: labelViewData.x,
                      y: labelViewData.y)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            self.createFromToView()
        }
    }
}

struct CaptureWeekOfYearView: View {
    let dateManagement: DateManagement

    fileprivate func createWeekOfYearView() -> some View {
        let labelViewData = self.dateManagement.createWeekOfYearViewData()
        return Text(labelViewData.contents)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color("Basic Green", bundle: .main))
            .font(Font.system(size: 13.0, weight: .regular))
            .position(x: labelViewData.x,
                      y: labelViewData.y)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            self.createWeekOfYearView()
        }
    }
}

struct CaptureMonthlyCalendarViewRepresentable: UIViewRepresentable {
    let monthlyCarendarView: MonthlyCalendarView
    
    func makeUIView(context: Context) -> UIView {
        return monthlyCarendarView.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct CaptureEventsView: View {
    let eventMangement: EventManagement

    fileprivate func createEventView(_ event: EKEvent) -> some View {
        print("\(#function):\(self.eventMangement.mainAreaEvents.count):\(event.title!)")
        let eventViewData = self.eventMangement.createEventViewData(event: event)
        let ekevents = self.eventMangement.checkMainAreaEvents(point: CGPoint(x: eventViewData.x, y: eventViewData.y + 1));
        var sameTimeEventIndex = 0
        if ekevents.count >= 2 {
            for ekevnet in ekevents {
                if ekevnet.eventIdentifier == event.eventIdentifier {
                    break;
                }
                sameTimeEventIndex = sameTimeEventIndex + 1
            }
        }
        let sameTimeEventAdjust: CGFloat = CGFloat(5 * sameTimeEventIndex)
        print("\(#function) - end")
        return Text(eventViewData.contents)
            .font(Font.system(size: 9.6, weight: .medium, design: .default))
            .padding(EdgeInsets(top: 0.0, leading: 6.0, bottom: 0.0, trailing: 0.0))
            .frame(width: eventViewData.width - sameTimeEventAdjust,
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
                        .position(x: (eventViewData.width - sameTimeEventAdjust) / 2, y: eventViewData.height + eventViewData.endSymbolYAdjust)
                }
                // 上
                if eventViewData.dispTopLine == true {
                    Path { path in
                            path.addLines([
                                CGPoint(x: 6, y: 0),
                                CGPoint(x: eventViewData.width - sameTimeEventAdjust, y: 0),
                            ])
                         }
                    .stroke(lineWidth: 1)
                }
                if eventViewData.isMove == false {
                    // 左
                    Path { path in
                            path.addLines([
                                CGPoint(x: 0, y: 5),
                                CGPoint(x: 0, y: eventViewData.height),
                            ])
                         }
                    .stroke(lineWidth: 1)
                }
                else {
                    // 真ん中
                    Path { path in
                            path.addLines([
                                CGPoint(x: (eventViewData.width - sameTimeEventAdjust) / 2, y: 0),
                                CGPoint(x: (eventViewData.width - sameTimeEventAdjust) / 2, y: eventViewData.height),
                            ])
                         }
                    .stroke(lineWidth: 1)
                }
                // 下
                if eventViewData.dispBottomLine == true {
                    Path { path in
                            path.addLines([
                                CGPoint(x: 0, y: eventViewData.height),
                                CGPoint(x: eventViewData.width - CGFloat(5 * sameTimeEventIndex), y: eventViewData.height),
                            ])
                         }
                    .stroke(lineWidth: 1)
                }
            })
            .background(eventViewData.color)
            .offset(x: eventViewData.x + CGFloat(5 * sameTimeEventIndex),
                    y: eventViewData.y)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(self.eventMangement.mainAreaEvents, id: \.self) { event in
                    createEventView(event)
                }
            }
        }
    }
}
