//
//  Device.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import Foundation
import UIKit

class Device {
    enum DType {
        case ipad_pro_12_9_6th
        case ipad_pro_12_9_6th_more_space
        case ipad_pro_13
        case ipad_pro_13_more_space
        case etc
    }

    // Prefer context-derived screen to avoid UIScreen.main deprecation on iOS 26+
    static func getDevie(for screen: UIScreen) -> DType {
        let width = screen.bounds.size.width
        var dtype: DType = .etc
        switch width {
        case 1600.0:
            dtype = .ipad_pro_13_more_space
        case 1590.0:
            dtype = .ipad_pro_12_9_6th_more_space
        case 1376.0:
            dtype = .ipad_pro_13
        case 1366.0:
            dtype = .ipad_pro_12_9_6th
        case 1024.0:
            print("iPad mini")
        default:
            print("???")
        }
        return dtype
    }

    // Convenience when you have a view (preferred in UIKit contexts)
    static func getDevie(from view: UIView) -> DType {
        if let screen = view.window?.windowScene?.screen {
            return getDevie(for: screen)
        }
        // Fallback: try the view's trait environment to infer a size class-based guess
        return getDevieFallback()
    }

    // Convenience when you have a view controller
    static func getDevie(from viewController: UIViewController) -> DType {
        if let screen = viewController.view.window?.windowScene?.screen {
            return getDevie(for: screen)
        }
        return getDevieFallback()
    }

    // Deprecated global fallback retained for legacy call sites without context.
    // Avoid calling this on iOS 26+ as UIScreen.main is deprecated.
    @available(iOS, introduced: 13.0, deprecated: 26.0, message: "Pass a contextual UIScreen (e.g., view.window.windowScene.screen)")
    static func getDevie() -> DType {
        #if swift(>=6.0)
        // On modern Swift/iOS, avoid using UIScreen.main; return conservative default.
        return getDevieFallback()
        #else
        return getDevie(for: UIScreen.main)
        #endif
    }

    // Minimal conservative fallback when no screen context is available.
    private static func getDevieFallback() -> DType {
        return .etc
    }
}
