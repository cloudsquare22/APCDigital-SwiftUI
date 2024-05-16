//
//  MainView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import SwiftUI
import SwiftData
import PencilKit

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase

    @Environment(DateManagement.self) private var dateManagement
    @Environment(EventManagement.self) private var eventMangement
    @Environment(DataOperation.self) private var dataOperation
    
    @State var pkCanvasView: PKCanvasView = PKCanvasView(frame: .zero)
    @State var pkToolPicker: PKToolPicker = PKToolPicker()

    @State var monthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 145, height: 105), day: Date.now)
    @State var nextMonthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 145, height: 105), day: Date.now, selectWeek: false)

    @State var longpressPoint: CGPoint = .zero
    @State var dispEventEditView: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Image("aptemplate", bundle: .main)
                    .resizable()
                    .scaledToFit()
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                DayTopAreaView()
                // Right Area
                Group {
                    MonthLabelView()
                    FromToView()
                    MonthlyCalendarViewRepresentable(monthlyCarendarView: self.$monthlyCalendarView)
                        .offset(x: self.monthlyCalendarView.getOffset().x,
                                y: self.monthlyCalendarView.getOffset().y)
                    MonthlyCalendarViewRepresentable(monthlyCarendarView: self.$nextMonthlyCalendarView)
                        .offset(x: self.nextMonthlyCalendarView.getOffset().x,
                                y: self.nextMonthlyCalendarView.getOffset().y + self.nextMonthlyCalendarView.MONTHLY_CALENDAR_HEIGHTMAX)
                    WeekOfYearView()
                }
                EventsView()
                PencilKitViewRepresentable(pkCanvasView: self.$pkCanvasView,
                                           pkToolPicker: self.$pkToolPicker,
                                           point: self.$longpressPoint)
                .gesture(DragGesture(coordinateSpace: .global)
                    .onEnded({ value in
                        let swipeType = self.swipeType(startLocation: value.startLocation,
                                                       location: value.location)
                        self.changePage(swipeType: swipeType)
                    })
                )
                .onChange(of: self.longpressPoint, { old, new in
                    print("#### \(new)")
                    let mainAreaEvents = self.eventMangement.checkMainAreaEvents(point: self.longpressPoint)
                    if mainAreaEvents.count == 0 {
                        if let eventData = self.eventMangement.createEventData(point: self.longpressPoint,
                                                                               daysDateComponents: self.dateManagement.daysDateComponents) {
                            self.eventMangement.operationEventData = eventData
                            self.dispEventEditView.toggle()
                        }
                    }
                    else {
                        if let eventData = self.eventMangement.createEventData(point: self.longpressPoint,
                                                                               daysDateComponents: self.dateManagement.daysDateComponents) {
                            self.eventMangement.operationEventData = eventData
                            self.eventMangement.operationEKEvents = mainAreaEvents
                            self.eventMangement.operationPoint = self.longpressPoint
                            self.dispEventEditView.toggle()
                        }
                    }
                })
                .sheet(isPresented: self.$dispEventEditView,
                       onDismiss: {
                    self.eventMangement.operationEventData = nil
                    self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                                     endDay: self.dateManagement.daysDateComponents[.sunday]!)
                    self.pkCanvasView.becomeFirstResponder()
                },
                       content: {
                    if let eventData = self.eventMangement.operationEventData {
                        EventEditView(eventData: eventData,
                                      eventDatas: self.eventMangement.operationEKEvents ?? [],
                                      point: self.longpressPoint)
                    }
                })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            print(Device.getDevie())
            self.dateManagement.setPageStartday(direction: .today)
            self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                             endDay: self.dateManagement.daysDateComponents[.sunday]!)
            self.eventMangement.updateCalendars()
        }
        .onChange(of: self.dateManagement.pagestartday, { old, new in
            if let day = new {
                self.monthlyCalendarView.update(day: day)
                if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: day) {
                    self.nextMonthlyCalendarView.update(day: nextMonth, selectWeek: false)
                }
            }
        })
        .onChange(of: self.dateManagement.pagestartday, { oldDate, newDate in
            if let date = oldDate {
                print("onchange olddate:\(date.printStyleString(style: .medium))")
                self.dataOperation.upsertPencilData(date: oldDate,
                                                    pagedata: self.pkCanvasView.drawing.dataRepresentation())
            }
            if let date = newDate {
                print("onchange newdate:\(date.printStyleString(style: .medium))")
                self.drawingPencilData(date: date)
            }
            self.pkCanvasView.becomeFirstResponder()
        })
        .onChange(of: scenePhase) { oldvalue, newvalue in
            switch(newvalue) {
            case .active:
                print("active")
            case .background:
                print("background")
            case .inactive:
                print("inactive")
                if oldvalue != .background {
                    if let date = self.dateManagement.pagestartday {
                        self.dataOperation.upsertPencilData(date: date,
                                                            pagedata: self.pkCanvasView.drawing.dataRepresentation())
                    }
                }
                else {
                    self.pkCanvasView.becomeFirstResponder()
                }
            @unknown default:
                print("default")
            }
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
            print("none")
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
    
    func drawingPencilData(date: Date?) {
        let pencilDatas: [PencilData] = self.dataOperation.selectPencilData(date: date)
        do {
            if pencilDatas.count > 0 {
                self.pkCanvasView.drawing  = try PKDrawing(data: pencilDatas[0].data)
                print("PKCanvasView select update")
            }
            else {
                self.pkCanvasView.drawing = PKDrawing()
                print("PKCanvasView initial")
            }
        }
        catch {
            print("PKCanvasView error:\(error)")
            self.pkCanvasView.drawing = PKDrawing()
        }
    }
}

#Preview {
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PencilData.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    return MainView()
        .environment(DateManagement())
        .environment(EventManagement())
        .environment(DataOperation(modelContext: sharedModelContainer.mainContext))
        .modelContainer(sharedModelContainer)
}
