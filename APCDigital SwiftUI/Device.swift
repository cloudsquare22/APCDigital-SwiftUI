//
//  Device.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import Foundation
import UIKit
import SwiftUI

class Device {
    private static func currentScreenWidth() -> CGFloat {
        var width: CGFloat = 1376.0
        // Try to resolve from an active window scene first
        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }),
           let screen = scene.screen as UIScreen? {
            width =  screen.bounds.size.width
        }
        return width
    }

    enum DType {
        case ipad_pro_12_9_6th
        case ipad_pro_12_9_6th_more_space
        case ipad_pro_13
        case ipad_pro_13_more_space
        case etc
    }
    static func getDevie() -> DType {
//        print("Device:\(UIScreen.main.bounds.size)")
        var dtype: DType = .etc
        let width = Self.currentScreenWidth()
        switch width {
        case 1600.0:
            dtype = .ipad_pro_13_more_space
        case 1590.0:
//            print("iPad Pro 12.9 第6世代 スペースを拡大")
            dtype = .ipad_pro_12_9_6th_more_space
        case 1376.0:
            dtype = .ipad_pro_13
        case 1366.0:
//            print("iPad Pro 12.9 第6世代 デフォルト")
            dtype = .ipad_pro_12_9_6th
        case 1024.0:
            print("iPad mini")
        default:
            print("???")
        }
        return dtype
    }
}
