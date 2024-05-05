//
//  DataOperation.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/05.
//

import Foundation
import SwiftUI
import SwiftData

@Observable class DataOperation {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func selectPencilData(date: Date?) -> [PencilData] {
        var pencilDatas: [PencilData] = []
        
        if let date = date {
            let dateComponents = Calendar.current.dateComponents(in: .current, from: date)
            print("Current:\(dateComponents.year!)/\(dateComponents.month!)/\(dateComponents.day!)")
            
            let year = dateComponents.year!
            let month = dateComponents.month!
            let day = dateComponents.day!
            let predicateNotebook = #Predicate<PencilData> {
                $0.year == year &&
                $0.month == month &&
                $0.day == day
            }
            let descriptorNotebook = FetchDescriptor<PencilData>(predicate: predicateNotebook)
            do {
                pencilDatas = try self.modelContext.fetch(descriptorNotebook)
                print("PencilData:\(pencilDatas.count)")
            }
            catch {
                print("PKCanvasView error:\(error)")
            }
        }
        return pencilDatas
    }
    
    func upsertPencilData(date: Date?, pagedata: Data) {
        print("pagedata:\(pagedata.count)")
        
        if let date: Date = date {
            let dateComponents = Calendar.current.dateComponents(in: .current, from: date)
            print("Upsert:\(dateComponents.year!)/\(dateComponents.month!)/\(dateComponents.day!)")
            
            let year = dateComponents.year!
            let month = dateComponents.month!
            let day = dateComponents.day!
            let predicateNotebook = #Predicate<PencilData> {
                $0.year == year &&
                $0.month == month &&
                $0.day == day
            }
            let descriptorNotebook = FetchDescriptor<PencilData>(predicate: predicateNotebook)
            let pencildatas = try! self.modelContext.fetch(descriptorNotebook)
            print("PencilData:\(pencildatas.count)")
            if pencildatas.count > 0 {
                print("PencilData update")
                pencildatas[0].data = pagedata
            }
            else {
                print("PencilData insert")
                let pencildata = PencilData(year: year, month: month, day: day, data: pagedata)
                self.modelContext.insert(pencildata)
            }
            try! self.modelContext.save()
        }
    }
}
