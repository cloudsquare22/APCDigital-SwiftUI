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
    let thisWeekStarDay: Date
    let thisWeekEndDay: Date
    @State var startDay: Date = Date()
    @State var endDay: Date = Date()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            HStack {
                Button(action: {
                    Task {
                        await self.exportThisWeekToImage(startDay: self.thisWeekStarDay, endDay: self.thisWeekEndDay)
                    }
                }, label: {
                    Label("This Week to Image", systemImage: "square.and.arrow.up.badge.clock")
                })
                .buttonStyle(.glass)
            }
            .padding(.bottom, 32)
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
            .navigationTitle("Export")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            let calendar = Calendar.current
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date()))!
            let startOfNextYear = calendar.date(byAdding: DateComponents(year: 1), to: startOfYear)!
            let endOfYear = calendar.date(byAdding: DateComponents(day: -1), to: startOfNextYear)!
            self.startDay = startOfYear
            self.endDay = endOfYear
        }
    }

    func exportThisWeekToImage(startDay: Date, endDay: Date) async {
        // 開始日から終了日までExportしていく
        print("size: \(self.size)")
        let dateManagement = DateManagement()
        let dataOperation = DataOperation(modelContext: self.modelContext)
        let eventManagement = EventManagement()

        dateManagement.setPageStartday(direction: .today, selectday: startDay)
        eventManagement.updateEvents(startDay: dateManagement.daysDateComponents[.monday]!,
                                     endDay: dateManagement.daysDateComponents[.sunday]!)
        let targetDay: Date = dateManagement.pagestartday!

        var image = UIImage()
        let pencilDatas = dataOperation.selectPencilData(date: targetDay)
        var paperMarkup: PaperMarkup = PaperMarkup(bounds: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let pencilData = pencilDatas.first {
            paperMarkup = try! PaperMarkup(dataRepresentation: pencilData.data)
            print("\(#function) PaperMarkupデータあり")
            if let cgimage = try! await self.updateThumbnail(paperMarkup) {
                image = UIImage(cgImage: cgimage)
                print("******")
            }
        }
        let uiimage = self.createPageImage(targetDay: targetDay,
                                           size: size,
                                           dateManagement: dateManagement,
                                           dataOperation: dataOperation,
                                           eventManagement: eventManagement,
                                           paperMarkupImage: image)
        if uiimage != nil, let data = uiimage?.jpegData(compressionQuality: 1.0) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            formatter.locale = Locale(identifier: "ja_JP")
            let stringStartDay = formatter.string(from: startDay)
            let stringEndDay = formatter.string(from: endDay)

            let filename = "APCDigital_\(stringStartDay)-\(stringEndDay).jpg"
            if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                let documentFileName = documentDirectories + "/" + filename
                self.removeFile(documentDirectories: documentDirectories, removefilename: filename)
                do {
                    try data.write(to: URL(fileURLWithPath: documentFileName))
                }
                catch {
                    print("Image write error")
                }
            }
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
            targetDay = dateManagement.pagestartday!

            var image = UIImage()
            let pencilDatas = dataOperation.selectPencilData(date: targetDay)
            var paperMarkup: PaperMarkup = PaperMarkup(bounds: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            if let pencilData = pencilDatas.first {
                paperMarkup = try! PaperMarkup(dataRepresentation: pencilData.data)
                print("\(#function) PaperMarkupデータあり")
                if let cgimage = try! await self.updateThumbnail(paperMarkup) {
                    image = UIImage(cgImage: cgimage)
                    print("******")
                }
            }
            autoreleasepool {

                print("PDF:\(targetDay!)")
                self.createPageImage(targetDay: targetDay!,
                                     size: size,
                                     dateManagement: dateManagement,
                                     dataOperation: dataOperation,
                                     eventManagement: eventManagement,
                                     pdfContext: pdfContext,
                                     paperMarkupImage: image)
                dateManagement.setPageStartday(direction: .next)
                eventManagement.updateEvents(startDay: dateManagement.daysDateComponents[.monday]!,
                                             endDay: dateManagement.daysDateComponents[.sunday]!)
            }
        }
        UIGraphicsEndPDFContext()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "ja_JP")
        let stringStartDay = formatter.string(from: startDay)
        let stringEndDay = formatter.string(from: endDay)

        let filename = "APCDigital_\(stringStartDay)-\(stringEndDay).pdf"
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentFileName = documentDirectories + "/" + filename
            self.removeFile(documentDirectories: documentDirectories, removefilename: filename)
            let result = pdfData.write(toFile: documentFileName, atomically: true)
            if result == true {
                print("write:\(documentFileName)")
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
                         pdfContext: CGContext,
                         paperMarkupImage: UIImage) {

        let monthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 146, height: 106), day: targetDay)
        let monthlyCalendarViewImage = monthlyCalendarView.view.asImage()
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: targetDay)!
        let nextMonthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 146, height: 106), day: nextMonth, selectWeek: false)
        let nextMonthlyCalendarViewImage = nextMonthlyCalendarView.view.asImage()

        let imageRenderer = ImageRenderer(content: CaptureView(dateManagement: dateManagement,
                                                               eventManagement: eventManagement,
                                                               size: size,
                                                               monthlyCalendarView: monthlyCalendarView,
                                                               monthlyCalendarViewImage: monthlyCalendarViewImage,
                                                               nextMonthlyCalendarView: nextMonthlyCalendarView,
                                                               nextMonthlyCalendarViewImage: nextMonthlyCalendarViewImage,
                                                               paperMarkupImage: paperMarkupImage)
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

    func createPageImage(targetDay: Date,
                         size: CGSize,
                         dateManagement: DateManagement,
                         dataOperation: DataOperation,
                         eventManagement: EventManagement,
                         paperMarkupImage: UIImage) -> UIImage? {

        let monthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 146, height: 106), day: targetDay)
        let monthlyCalendarViewImage = monthlyCalendarView.view.asImage()
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: targetDay)!
        let nextMonthlyCalendarView: MonthlyCalendarView = MonthlyCalendarView(frame: CGRect(x: 0, y: 0, width: 146, height: 106), day: nextMonth, selectWeek: false)
        let nextMonthlyCalendarViewImage = nextMonthlyCalendarView.view.asImage()

        let imageRenderer = ImageRenderer(content: CaptureView(dateManagement: dateManagement,
                                                               eventManagement: eventManagement,
                                                               size: size,
                                                               monthlyCalendarView: monthlyCalendarView,
                                                               monthlyCalendarViewImage: monthlyCalendarViewImage,
                                                               nextMonthlyCalendarView: nextMonthlyCalendarView,
                                                               nextMonthlyCalendarViewImage: nextMonthlyCalendarViewImage,
                                                               paperMarkupImage: paperMarkupImage)
        )
        imageRenderer.scale = 2.0
        imageRenderer.isOpaque = true
        return imageRenderer.uiImage
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

    func updateThumbnail(_ markupModel: PaperMarkup) async throws -> CGImage? {
        let thumbnailSize = CGSize(width: self.size.width, height: self.size.height)
        let scale = Device.screenScale()
        guard let context = makeCGContext(size: thumbnailSize, scale: scale) else {
            throw NSError(domain: "ThumbnailView", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create CGContext"])
        }

        // 背景を指定する場合、指定なしで透過
//        context.setFillColor(gray: 1, alpha: 1)
//        context.fill(CGRect(origin: .zero, size: CGSize(width: thumbnailSize.width * scale, height: thumbnailSize.height * scale)))

        context.saveGState()

        // UIKit(上が0)とCoreGraphics(下が0)の座標系差を吸収
        context.translateBy(x: 0, y: thumbnailSize.height * scale)
        context.scaleBy(x: 1, y: -1)
        
        context.scaleBy(x: scale, y: scale)
        await markupModel.draw(in: context, frame: CGRect(origin: .zero, size: thumbnailSize))
        context.restoreGState()

        return context.makeImage()
    }
    
    private func makeCGContext(size: CGSize, scale: CGFloat) -> CGContext? {
        let width = Int(size.width * scale)
        let height = Int(size.height * scale)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        return CGContext(data: nil,
                         width: width,
                         height: height,
                         bitsPerComponent: 8,
                         bytesPerRow: 0,
                         space: colorSpace,
                         bitmapInfo: bitmapInfo)
    }

    
}

#Preview {
    ExportView(size: CGSize(),
               thisWeekStarDay: Date(),
               thisWeekEndDay:Date())
}

