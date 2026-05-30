//
//  AppDelegate.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import SwiftUI
import EventKit

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(#function)
        let authorizationStatus = EKEventStore.authorizationStatus(for: .event)
        let eventStore = EKEventStore()
        print("EKEventStore.authorizationStatus:\(authorizationStatus)")
        if authorizationStatus == .fullAccess {
            print("Access OK")
        }
        else if authorizationStatus == .notDetermined {
            eventStore.requestFullAccessToEvents(completion: { (granted, error) in
                if granted {
                    print("Accessible")
                }
                else {
                    print("Access denied")
                }
            })
        }
        
        // AppDelegate.swift の didFinishLaunchingWithOptions 内に追加
        let info = Bundle.main.infoDictionary ?? [:]
        let iPhone = info["UISupportedInterfaceOrientations"] as? [String] ?? []
        let iPad = info["UISupportedInterfaceOrientations~ipad"] as? [String] ?? []
        let requiresFullScreen = info["UIRequiresFullScreen"] as? Bool
        
        print("UISupportedInterfaceOrientations (iPhone): \(iPhone)")
        print("UISupportedInterfaceOrientations~ipad: \(iPad)")
        print("UIRequiresFullScreen: \(String(describing: requiresFullScreen))")
        
        return true
    }
    
    // Restrict orientation at runtime while keeping Info.plist broad enough (include Portrait on iPhone)
    // This avoids relying on deprecated UIRequiresFullScreen on iOS 26+
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // Lock to landscape for all devices at runtime
        return .landscape
        // If you ever need per-device behavior:
        // if UIDevice.current.userInterfaceIdiom == .pad { return .landscape } else { return .landscape }
    }
}
