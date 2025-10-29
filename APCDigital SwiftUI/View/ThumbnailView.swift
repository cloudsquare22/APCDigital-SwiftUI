//
//  ThumbnailView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/10/28.
//

import SwiftUI
import PaperKit
import CoreGraphics
import UIKit

struct ThumbnailView: View {
    let markupModel: PaperMarkup?
    let size: CGSize
    
    @State private var thumbnail: CGImage? = nil
    
    var body: some View {
        Group {
            if let thumbnail {
                Image(decorative: thumbnail, scale: Device.screenScale(), orientation: .up)
                    .resizable()
                    .scaledToFit()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                    Text("No thumbnail")
                        .foregroundStyle(.secondary)
                }
                .frame(width: 200, height: 200)
            }
        }
        .background(.gray)
        .task {
            do {
                if let markup = self.markupModel {
                    try await self.updateThumbnail(markup)
                }
            } catch {
                // You can log or handle the error here
                print("Failed to update thumbnail: \(error)")
            }
        }
    }
    
    @MainActor func updateThumbnail(_ markupModel: PaperMarkup) async throws {
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

        if let image = context.makeImage() {
            await MainActor.run { self.thumbnail = image }
        }
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
//    ThumbnailView()
}

