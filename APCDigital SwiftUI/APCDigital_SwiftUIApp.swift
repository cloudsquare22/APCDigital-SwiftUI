//
//  APCDigital_SwiftUIApp.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/29.
//

import SwiftUI
import SwiftData

@main
struct APCDigital_SwiftUIApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @State private var dateamanagement: DateManagement = DateManagement()
    @State private var eventMangement: EventManagement = EventManagement()

    var sharedModelContainer: ModelContainer = {
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

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(self.dateamanagement)
                .environment(self.eventMangement)
                .environment(DataOperation(modelContext: self.sharedModelContainer.mainContext))
        }
        .modelContainer(sharedModelContainer)
    }
}
