//
//  PaperMarkupViewControllerRepresentable.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/10/06.
//

import Foundation
import SwiftUI
import UIKit
import PaperKit
import PencilKit

struct PaperMarkupViewControllerRepresentable: UIViewControllerRepresentable {
    let viewSize: CGSize
    @Binding var pkToolPicker: PKToolPicker

    func makeUIViewController(context: Context) -> PaperMarkupViewController {
        let markupModel = PaperMarkup(bounds: CGRect(x: 0, y: 0, width: self.viewSize.width, height: self.viewSize.height))
        let paperViewController = PaperMarkupViewController(markup: markupModel, supportedFeatureSet: .latest)
        paperViewController.view.becomeFirstResponder()
        
        self.pkToolPicker.addObserver(paperViewController)
        paperViewController.pencilKitResponderState.activeToolPicker = self.pkToolPicker
        paperViewController.pencilKitResponderState.toolPickerVisibility = .visible
        paperViewController.addButtonAction(toolPicker: self.pkToolPicker)
        paperViewController.delegate = context.coordinator
        let contentView = UIView(frame: .zero)
        contentView.isOpaque = false
        contentView.backgroundColor = .clear
        paperViewController.contentView = contentView
        paperViewController.view.frame = .zero
        paperViewController.view.backgroundColor = .clear
        paperViewController.view.isOpaque = false
        return paperViewController
    }
    
    func updateUIViewController(_ paperMarkupViewController: PaperMarkupViewController, context: Context) {
    }
    
    class Coordinator: NSObject, PaperMarkupViewController.Delegate {
        let parent: PaperMarkupViewControllerRepresentable
        
        init(parent: PaperMarkupViewControllerRepresentable) {
            self.parent = parent
        }
        
        // PaperMarkupViewController.Delegate
        func paperMarkupViewControllerDidChangeMarkup(_ paperMarkupViewController: PaperMarkupViewController) {
            print("\(#function)")
        }
        
        func paperMarkupViewControllerDidChangeSelection(_ paperMarkupViewController: PaperMarkupViewController) {
            print("\(#function)")
        }
        
        func paperMarkupViewControllerDidBeginDrawing(_ paperMarkupViewController: PaperMarkupViewController) {
            print("\(#function)")
        }
        
        func paperMarkupViewControllerDidChangeContentVisibleFrame(_ paperMarkupViewController: PaperMarkupViewController) {
            print("\(#function)")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

//extension PaperMarkupViewController: @retroactive MarkupEditViewController.Delegate {
extension PaperMarkupViewController {
    func addButtonAction(toolPicker: PKToolPicker) {
        toolPicker.accessoryItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonPressed(_:)))
    }
    
    @objc func plusButtonPressed(_ button: UIBarButtonItem) {
        let markupEditViewController = MarkupEditViewController(supportedFeatureSet: .latest)
        markupEditViewController.modalPresentationStyle = .popover
        markupEditViewController.popoverPresentationController?.barButtonItem = button
//        markupEditViewController.delegate = self
        markupEditViewController.delegate = self as? any MarkupEditViewController.Delegate
        self.present(markupEditViewController, animated: true)
    }
    
//    public func markupEditViewController(_ markupEditViewController: MarkupEditViewController, insertNewShape type: ShapeConfiguration.Shape) {
//        print("\(#function)")
//    }
//
//    public func markupEditViewControllerInsertNewTextbox(_ markupEditViewController: MarkupEditViewController) {
//        print("\(#function)")
//    }
//
//    public func markupEditViewController(_ markupEditViewController: MarkupEditViewController, insertNewLineWithStartMarker lineStartMarker: Bool, endMarker lineEndMarker: Bool) {
//        print("\(#function)")
//    }
//
//    public func markupEditViewController(_ markupEditViewController: MarkupEditViewController, insertNewContents toInsert: PaperMarkup) {
//        print("\(#function)")
//    }
    
}

