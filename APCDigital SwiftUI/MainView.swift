//
//  MainView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import SwiftUI
import SwiftData
import PencilKit
import PaperKit

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase

    @Environment(DateManagement.self) private var dateManagement
    @Environment(EventManagement.self) private var eventMangement
    @Environment(DataOperation.self) private var dataOperation
    
    @State var pkCanvasView: PKCanvasView = RapPKCanvasView(frame: .zero)
    @State var pkToolPicker: PKToolPicker = PKToolPicker()
    @State var paperMarkupViewController: PaperMarkupViewController?

    @State var monthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 145, height: 105), day: Date.now)
    @State var nextMonthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 145, height: 105), day: Date.now, selectWeek: false)

//    @State var longpressPoint: CGPoint = .zero
    @State var dispEventEditView: Bool = false
    @State var dispDaySelectView: Bool = false
    
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
                    WeekOfYearView()
                }
                EventsView()
                PaperMarkupViewControllerRepresentable(viewSize: geometry.size,
                                                       pkToolPicker: self.$pkToolPicker,
                                                       onCreated: { paperMarkupViewController in
                        DispatchQueue.main.async {
                        self.paperMarkupViewController = paperMarkupViewController
                    }
                })
//                PencilKitViewStandardRepresentable(pkCanvasView: self.$pkCanvasView,
//                                                   pkToolPicker: self.$pkToolPicker)
//                PencilKitViewRepresentable(pkCanvasView: self.$pkCanvasView,
//                                           pkToolPicker: self.$pkToolPicker,
//                                           point: self.$longpressPoint)
                .onTapGesture(count: 2, perform: { point in
                    print("Double Tap!! \(point)")
                    if let newEventData = self.eventMangement.createEventData(point: point,
                                                                              daysDateComponents: self.dateManagement.daysDateComponents) {
                        var editEvantDatas: [EventData] = []
                        editEvantDatas.append(newEventData)
                        editEvantDatas.append(contentsOf: self.eventMangement.createAllAreaEventDatas(point: point))
                        self.eventMangement.operationEventDatas = editEvantDatas
                        self.dispEventEditView.toggle()
                    }
                })
//                .onChange(of: self.longpressPoint, { old, new in
//                    if let newEventData = self.eventMangement.createEventData(point: self.longpressPoint,
//                                                                           daysDateComponents: self.dateManagement.daysDateComponents) {
//                        var editEvantDatas: [EventData] = []
//                        editEvantDatas.append(newEventData)
//                        editEvantDatas.append(contentsOf: self.eventMangement.createAllAreaEventDatas(point: self.longpressPoint))
//                        self.eventMangement.operationEventDatas = editEvantDatas
//                        self.dispEventEditView.toggle()
//                    }
//                })
                .sheet(isPresented: self.$dispEventEditView,
                       onDismiss: {
                    self.eventMangement.operationEventDatas = []
                    self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                                     endDay: self.dateManagement.daysDateComponents[.sunday]!)
                    self.pkCanvasView.becomeFirstResponder()
                },
                       content: {
                    if self.eventMangement.operationEventDatas.isEmpty == false {
                        EventEditView(eventDatas: self.eventMangement.operationEventDatas)
                    }
                })
//                PencilCaseView(pkCanvasView: self.$pkCanvasView,
//                               pkToolPicker: self.$pkToolPicker,
//                               paperMarkupViewController: self.$paperMarkupViewController)
//                    .offset(x: 720, y: 16)
                
                // Right Area at the very top
                Group {
                    MonthlyCalendarViewRepresentable(monthlyCarendarView: self.$monthlyCalendarView)
                        .frame(width: 145, height: 105)
                        .offset(x: self.monthlyCalendarView.getOffset().x,
                                y: self.monthlyCalendarView.getOffset().y)
                    MonthlyCalendarViewRepresentable(monthlyCarendarView: self.$nextMonthlyCalendarView)
                        .frame(width: 145, height: 105)
                        .offset(x: self.nextMonthlyCalendarView.getOffset().x,
                                y: self.nextMonthlyCalendarView.getOffset().y + self.nextMonthlyCalendarView.MONTHLY_CALENDAR_HEIGHTMAX)
                }
                .onTapGesture {
                    print("Monthly Calenar Tap")
                    self.dispDaySelectView.toggle()
                }
                .gesture(DragGesture(coordinateSpace: .global)
                    .onEnded({ value in
                        let swipeType = self.swipeType(startLocation: value.startLocation,
                                                       location: value.location)
                        self.changePage(swipeType: swipeType)
                    })
                )
                .sheet(isPresented: self.$dispDaySelectView,
                       onDismiss: {
//                    self.pkCanvasView.becomeFirstResponder()
                },
                       content: {
                    DaySelectView()
                })
            }
            .onChange(of: self.dateManagement.pagestartday, { oldDate, newDate in
                if let date = oldDate {
                    print("onchange olddate:\(date.printStyleString(style: .medium))")
//                    self.dataOperation.upsertPencilData(date: oldDate,
//                                                        pagedata: self.pkCanvasView.drawing.dataRepresentation())
                    if let markup = self.paperMarkupViewController?.markup {
                        Task {
                            try! await self.dataOperation.upsertPencilData(date: oldDate,
                                                                           pagedata: markup.dataRepresentation())
                        }

                    }
                }
                if let date = newDate {
                    print("onchange newdate:\(date.printStyleString(style: .medium))")
                    self.drawingPencilData(date: date, geometry: geometry)
                }
                self.pkCanvasView.becomeFirstResponder()
            })
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            print(Device.getDevie())
            self.dateManagement.setPageStartday(direction: .today)
            self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                             endDay: self.dateManagement.daysDateComponents[.sunday]!)
            self.eventMangement.updateCalendars()
            self.pkCanvasView.becomeFirstResponder()
        }
        .onChange(of: self.dateManagement.pagestartday, { old, new in
            if let day = new {
                print("ページ日付更新")
                self.monthlyCalendarView.update(day: day)
                if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: day) {
                    self.nextMonthlyCalendarView.update(day: nextMonth, selectWeek: false)
                }
            }
            self.pkCanvasView.becomeFirstResponder()
        })
        .onChange(of: scenePhase) { oldvalue, newvalue in
            switch(newvalue) {
            case .active:
                print("active")
//                self.pkCanvasView.becomeFirstResponder()
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
    
    func drawingPencilData(date: Date?, geometry: GeometryProxy) {
        let pencilDatas: [PencilData] = self.dataOperation.selectPencilData(date: date)
        do {
            if pencilDatas.count > 0 {
                let markupModel = try PaperMarkup(dataRepresentation: pencilDatas[0].data)
//                self.pkCanvasView.drawing  = try PKDrawing(data: pencilDatas[0].data)
                if let controller = self.paperMarkupViewController {
                    controller.markup = markupModel
                    controller.view.becomeFirstResponder()
                    self.pkToolPicker.removeObserver(controller)
                    self.pkToolPicker.addObserver(controller)
                    controller.pencilKitResponderState.activeToolPicker = self.pkToolPicker
                    controller.pencilKitResponderState.toolPickerVisibility = .visible
                    let contentView = UIView(frame: .zero)
                    contentView.isOpaque = false
                    contentView.backgroundColor = .clear
                    controller.contentView = contentView
                }

                print("PKCanvasView select update")
            }
            else {
//                self.pkCanvasView.drawing = PKDrawing()
                if let controller = self.paperMarkupViewController {
                    controller.markup = PaperMarkup(bounds: controller.view.bounds)
                    controller.view.becomeFirstResponder()
                    self.pkToolPicker.removeObserver(controller)
                    self.pkToolPicker.addObserver(controller)
                    controller.pencilKitResponderState.activeToolPicker = self.pkToolPicker
                    controller.pencilKitResponderState.toolPickerVisibility = .visible
                    let contentView = UIView(frame: .zero)
                    contentView.isOpaque = false
                    contentView.backgroundColor = .clear
                    controller.contentView = contentView
                }
                print("PKCanvasView initial")
            }
        }
        catch {
            print("PKCanvasView error:\(error)")
//            self.pkCanvasView.drawing = PKDrawing()
            if let controller = self.paperMarkupViewController {
                controller.markup = PaperMarkup(bounds: controller.view.bounds)
                controller.view.becomeFirstResponder()
                self.pkToolPicker.removeObserver(controller)
                self.pkToolPicker.addObserver(controller)
                controller.pencilKitResponderState.activeToolPicker = self.pkToolPicker
                controller.pencilKitResponderState.toolPickerVisibility = .visible
                let contentView = UIView(frame: .zero)
                contentView.isOpaque = false
                contentView.backgroundColor = .clear
                controller.contentView = contentView
            }
        }
        self.pkCanvasView.isHidden = false
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
