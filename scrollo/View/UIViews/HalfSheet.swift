//
//  HalfSheet.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI
import UIKit
import UISheetPresentationControllerCustomDetent

extension View {
    
    func halfSheet<SheetView: View>(isPresent: Binding<Bool>, @ViewBuilder sheetView: @escaping () -> SheetView, onEnd: @escaping () -> ()) -> some View {
        
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), isPresent: isPresent, onEnd: onEnd)
            )
    }
}

struct HalfSheetHelper<SheetView: View> : UIViewControllerRepresentable {
    
    var sheetView: SheetView
    @Binding var isPresent: Bool
    var onEnd: () -> ()
    
    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        controller.view.backgroundColor = .clear
        return controller
    }
    
        
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if isPresent {
            
            let sheetController = MediumHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            
            uiViewController.present(sheetController, animated: true)
        } else {
            uiViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        
        var parent: HalfSheetHelper
        
        init (parent: HalfSheetHelper) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.isPresent = false
            
            parent.onEnd()
        }
        
    }
}

class MediumHostingController<Content: View>: UIHostingController<Content> {
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        
        if let presentationController = presentationController as? UISheetPresentationController {
            
            presentationController.detents = [
                .custom(240)
            ]
            
            presentationController.prefersGrabberVisible = true
        }
    }
}


