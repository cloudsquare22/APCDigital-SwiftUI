//
//  ExportView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/10/23.
//

import SwiftUI
import PaperKit

struct ExportView: View {
    let size: CGSize
    @State var startDay: Date = Date()
    @State var endDay: Date = Date()
    @Environment(\.modelContext) private var modelContext

    static var exportFileURL: URL? = nil

    var body: some View {
        HStack {
            Label("Start", systemImage: "calendar")
            DatePicker("Start",
                       selection: self.$startDay,
                       displayedComponents: [.date])
            .datePickerStyle(.automatic)
            .labelsHidden()
            Text("〜")
            Label("End", systemImage: "calendar")
            DatePicker("End",
                       selection: self.$endDay,
                       displayedComponents: [.date])
            .datePickerStyle(.automatic)
            .labelsHidden()
        }
        Button(action: {
            Task {
                await self.exportPDF(startDay: self.startDay, endDay: self.endDay)
            }
        }, label: {
            Label("Execute", systemImage: "square.and.arrow.up.on.square")
        })
        .buttonStyle(.glass)
        .onAppear {
            let calendar = Calendar.current
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date()))!
            let startOfNextYear = calendar.date(byAdding: DateComponents(year: 1), to: startOfYear)!
            let endOfYear = calendar.date(byAdding: DateComponents(day: -1), to: startOfNextYear)!
            self.startDay = startOfYear
            self.endDay = endOfYear
        }
    }
    
    func exportPDF(startDay: Date, endDay: Date) async {
        // 開始日から終了日までExportしていく
        print("size: \(self.size)")
        let dateManagement = DateManagement()
        let dataOperation = DataOperation(modelContext: self.modelContext)
        let eventManagement = EventManagement()

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height), nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return}
        dateManagement.setPageStartday(direction: .today, selectday: startDay)
        eventManagement.updateEvents(startDay: dateManagement.daysDateComponents[.monday]!,
                                     endDay: dateManagement.daysDateComponents[.sunday]!)
        var targetDay: Date? = nil
        while targetDay != dateManagement.pagestartday && dateManagement.pagestartday!.isPastClose(compare: endDay) == true {
            autoreleasepool {
                targetDay = dateManagement.pagestartday!

                print("PDF:\(targetDay!)")
                self.createPageImage(targetDay: targetDay!,
                                     size: size,
                                     dateManagement: dateManagement,
                                     dataOperation: dataOperation,
                                     eventManagement: eventManagement,
                                     pdfContext: pdfContext)
                dateManagement.setPageStartday(direction: .next)
                eventManagement.updateEvents(startDay: dateManagement.daysDateComponents[.monday]!,
                                             endDay: dateManagement.daysDateComponents[.sunday]!)
            }
        }
        UIGraphicsEndPDFContext()
        
        let filename = "APCDigital.pdf"
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentFileName = documentDirectories + "/" + filename
            self.removeFile(documentDirectories: documentDirectories, removefilename: filename)
            let result = pdfData.write(toFile: documentFileName, atomically: true)
            if result == true {
                print("write:\(documentFileName)")
//                ExportView.exportFileURL = URL(fileURLWithPath: documentFileName)
//                self.dispActivityView.toggle()
            }
            else {
                print("PDF write error")
            }
        }
    }
    
    func createPageImage(targetDay: Date,
                         size: CGSize,
                         dateManagement: DateManagement,
                         dataOperation: DataOperation,
                         eventManagement: EventManagement,
                         pdfContext: CGContext) {
        let pencilDatas = dataOperation.selectPencilData(date: targetDay)
        var paperMarkup: PaperMarkup = PaperMarkup(bounds: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let pencilData = pencilDatas.first {
            paperMarkup = try! PaperMarkup(dataRepresentation: pencilData.data)
            print("\(#function) PaperMarkupデータあり")
        }

        // PaperMarkupをどうやって画像にするか？
        // Contextエラーになるし
//        Task {
//            await paperMarkup.draw(in: pdfContext, frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
//        }

        let monthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 146, height: 106), day: targetDay)
        let monthlyCalendarViewImage = monthlyCalendarView.view.asImage()
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: targetDay)!
        let nextMonthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 146, height: 106), day: nextMonth, selectWeek: false)
        let nextMonthlyCalendarViewImage = nextMonthlyCalendarView.view.asImage()

        let image = UIImage()
        let imageRenderer = ImageRenderer(content: CaptureView(dateManagement: dateManagement,
                                                               eventManagement: eventManagement,
                                                               size: size,
                                                               monthlyCalendarView: monthlyCalendarView,
                                                               monthlyCalendarViewImage: monthlyCalendarViewImage,
                                                               nextMonthlyCalendarView: nextMonthlyCalendarView,
                                                               nextMonthlyCalendarViewImage: nextMonthlyCalendarViewImage,
                                                               paperMarkupImage: image)
        )

        imageRenderer.render { size, render in
            UIGraphicsBeginPDFPage()

            pdfContext.saveGState()
            pdfContext.translateBy(x: 0, y: size.height)
            pdfContext.scaleBy(x: 1, y: -1)

            render(pdfContext)

            pdfContext.restoreGState()
        }
    }
    
    func removeFile(documentDirectories: String, removefilename: String) {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: documentDirectories)
            print(files)
            for file in files {
                if file == removefilename {
                    try FileManager.default.removeItem(atPath: documentDirectories + "/" + file)
                }
            }
        }
        catch {
            print(error)
        }
    }
    
}

#Preview {
    ExportView(size: CGSize())
}

