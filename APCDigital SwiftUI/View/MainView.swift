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
    
    @State var pkToolPicker: PKToolPicker = PKToolPicker()
    @State var paperMarkupViewController: PaperMarkupViewController?

    @State var monthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 145, height: 105), day: Date.now)
    @State var nextMonthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 145, height: 105), day: Date.now, selectWeek: false)

    @State var dispEventEditView: Bool = false
    @State var dispDaySelectView: Bool = false
    @State var dispEventListView: Bool = false
    @State var dispExportView: Bool = false

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
//                .onTapGesture {
//                    print("Monthly Calenar Tap")
//                    self.dispDaySelectView.toggle()
//                }
//                .gesture(DragGesture(coordinateSpace: .global)
//                    .onEnded({ value in
//                        let swipeType = self.swipeType(startLocation: value.startLocation,
//                                                       location: value.location)
//                        self.changePage(swipeType: swipeType)
//                    })
//                )
                PaperMarkupViewControllerRepresentable(viewSize: geometry.size,
                                                       pkToolPicker: self.$pkToolPicker,
                                                       onCreated: { paperMarkupViewController in
                    DispatchQueue.main.async {
                        self.paperMarkupViewController = paperMarkupViewController
                        self.drawingPencilData(date: self.dateManagement.pagestartday)
                    }
                })
                
                MenuView(dispEventEditView: self.$dispEventEditView,
                         dispEventListView: self.$dispEventListView,
                         dispExportView: self.$dispExportView,
                         dispDaySelectView: self.$dispDaySelectView)
                    .glassEffect()
                    .position(x: geometry.size.width / 2, y: 30)
//                    .offset(x: geometry.size.width / 2 - 90, y: 8)
//                PencilCaseView(pkToolPicker: self.$pkToolPicker,
//                               paperMarkupViewController: self.$paperMarkupViewController)
//                    .glassEffect()
//                    .offset(x: geometry.size.width - 300, y: 8)
            }
            .sheet(isPresented: self.$dispEventEditView,
                   onDismiss: {
                self.eventMangement.operationEventDatas = []
                self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                                 endDay: self.dateManagement.daysDateComponents[.sunday]!)
            },
                   content: {
                EventEditView(eventDatas: self.eventMangement.operationEventDatas)
                    .frame(height: 800)
                    .interactiveDismissDisabled(true)
            })
            .sheet(isPresented: self.$dispEventListView, onDismiss: {
                self.eventMangement.operationEventDatas = []
                self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                                 endDay: self.dateManagement.daysDateComponents[.sunday]!)
            }, content: {
                EventListView(dispEventEditView: self.$dispEventEditView)
                    .frame(width: 800, height: 800)
                    .interactiveDismissDisabled(true)
            })
            .sheet(isPresented: self.$dispDaySelectView,
                   onDismiss: {
            },
                   content: {
                DaySelectView()
                    .interactiveDismissDisabled(true)
            })
            .sheet(isPresented: self.$dispExportView,
                   onDismiss: {
            },
                   content: {
                ExportView(size: geometry.size,
                           thisWeekStarDay: self.eventMangement.pageStartDate,
                           thisWeekEndDay: self.eventMangement.pageEndDate)
                .interactiveDismissDisabled(true)
//                ThumbnailView(markupModel: self.paperMarkupViewController!.markup,
//                              size: geometry.size)
            })
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
            if let date = old {
                print("onchange olddate:\(date.printStyleString(style: .medium))")
                if let markup = self.paperMarkupViewController?.markup {
                    Task {
                        try! await self.dataOperation.upsertPencilData(date: old,
                                                                       pagedata: markup.dataRepresentation())
                    }
                }
            }
            if let date = new {
                print("onchange newdate:\(date.printStyleString(style: .medium))")
                self.drawingPencilData(date: date)
                self.monthlyCalendarView.update(day: date)
                if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: date) {
                    self.nextMonthlyCalendarView.update(day: nextMonth, selectWeek: false)
                }
            }
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
                    if let date = self.dateManagement.pagestartday,
                        let markup = self.paperMarkupViewController?.markup {
                        Task {
                            try! await self.dataOperation.upsertPencilData(date: date,
                                                                           pagedata: markup.dataRepresentation())
                        }
                    }
                }
            @unknown default:
                print("default")
            }
        }
        .statusBarHidden(true)
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
        case .down:
            self.dateManagement.setPageStartday(direction: .today, selectday: Date.now)
            self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                             endDay: self.dateManagement.daysDateComponents[.sunday]!)
            self.eventMangement.updateCalendars()
        case .up, .none:
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
        if pencilDatas.count > 0 {
            print("Data size:\(pencilDatas[0].data.count)")
            self.initializationPaperMarkupViewController(data: pencilDatas[0].data)
        }
        else {
            self.initializationPaperMarkupViewController()
        }
    }
    
    func initializationPaperMarkupViewController(data: Data? = nil) {
        print("MainView.\(#function)")
        if let controller = self.paperMarkupViewController {
            if data == nil {
                controller.markup = PaperMarkup(bounds: controller.view.bounds)
                print("PaperMarkup initial")
            }
            else {
                let paperMarkup = try! PaperMarkup(dataRepresentation: data!)
                controller.markup = paperMarkup
                print("PaperMarkup select update")
            }
            controller.view.becomeFirstResponder()
            self.pkToolPicker.removeObserver(controller)
            self.pkToolPicker.addObserver(controller)
            controller.pencilKitResponderState.activeToolPicker = self.pkToolPicker
            controller.pencilKitResponderState.toolPickerVisibility = .visible
            
            controller.setClearBackground()
            controller.view.disableScrollViewBounce()
        }
        else {
            print("paperMarkupViewController is nil")
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
