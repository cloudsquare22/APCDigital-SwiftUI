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
        return true
    }
    
    var orientationLock: UIInterfaceOrientationMask = .all // 宣言上は広めに

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        print("*** UIInterfaceOrientationMask ***")
        return [.landscapeLeft, .landscapeRight]
    }
    
}
