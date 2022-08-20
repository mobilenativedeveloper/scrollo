//
//  UIBottomSheet.swift
//  scrollo
//
//  Created by Artem Strelnik on 20.08.2022.
//

import SwiftUI
import UISheetPresentationControllerCustomDetent
//
//struct BottomSheet<Content: View>: UIViewControllerRepresentable {
//
//    @Binding var isPresent: Bool
//    var content: Content
//    var backgroundColor: Color
//    var prefersGrabberVisible: Bool
//    var detents: [UISheetPresentationController.Detent]
//
//
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let controller = UIViewController()
//        return controller
//    }
//
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
//        var parent: BottomSheet
//        init(_ parent: BottomSheet) {
//                self.parent = parent
//        }
//        //Adjust the variable when the user dismisses with a swipe
//        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//            if parent.isPresent{
//                parent.isPresent = false
//            }
//        }
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        let sheetPresentationController = SheetPresentationController(rootView: self.content, detents: detents, prefersGrabberVisible: prefersGrabberVisible, backgroundColor: backgroundColor)
//        if self.isPresent {
//            uiViewController.present(sheetPresentationController, animated: true, completion: nil)
//        } else {
//            uiViewController.dismiss(animated: true, completion: nil)
//        }
//    }
//}
//
//class SheetPresentationController<Content: View>: UIHostingController<Content>  {
//    let detents: [UISheetPresentationController.Detent]
//    let prefersGrabberVisible: Bool
//    let backgroundColor: Color
//
//    init(rootView: Content, detents: [UISheetPresentationController.Detent], prefersGrabberVisible: Bool, backgroundColor: Color) {
//        self.detents = detents
//        self.prefersGrabberVisible = prefersGrabberVisible
//        self.backgroundColor = backgroundColor
//        super.init(rootView: rootView)
//    }
//
//    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        view.backgroundColor = UIColor(backgroundColor)
//
//        if let presentationController = presentationController as? UISheetPresentationController {
//
//            presentationController.detents = detents
//
//            presentationController.prefersGrabberVisible = prefersGrabberVisible
//        }
//    }
//}


struct BottomSheet<Content: View>: UIViewControllerRepresentable {
    
    @Binding var isPresent: Bool
    var content: Content
    var backgroundColor: Color
    var prefersGrabberVisible: Bool
    var detents: [UISheetPresentationController.Detent]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CustomSheetViewController<Content> {
        let vc = CustomSheetViewController(coordinator: context.coordinator, detents: detents, prefersGrabberVisible: prefersGrabberVisible, backgroundColor: backgroundColor, content: {content})
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CustomSheetViewController<Content>, context: Context) {
        if isPresent{
            uiViewController.presentModalView()
        } else{
            uiViewController.dismissModalView()
        }
    }
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var parent: BottomSheet
        init(_ parent: BottomSheet) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            if parent.isPresent{
                parent.isPresent = false
            }
        }
    }
}


class CustomSheetViewController<Content: View>: UIViewController {
    let content: Content
    let coordinator: BottomSheet<Content>.Coordinator
    let detents : [UISheetPresentationController.Detent]
    let backgroundColor: Color
    let prefersGrabberVisible: Bool
    
    init(coordinator: BottomSheet<Content>.Coordinator, detents : [UISheetPresentationController.Detent], prefersGrabberVisible: Bool, backgroundColor: Color, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.coordinator = coordinator
        self.detents = detents
        self.prefersGrabberVisible = prefersGrabberVisible
        self.backgroundColor = backgroundColor
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissModalView(){
        dismiss(animated: true, completion: nil)
    }
        
    func presentModalView(){
        let hostingController = UIHostingController(rootView: content)
        
        hostingController.modalPresentationStyle = .popover
        hostingController.presentationController?.delegate = coordinator as UIAdaptivePresentationControllerDelegate
        hostingController.view.backgroundColor = UIColor(backgroundColor)
        hostingController.modalTransitionStyle = .coverVertical
        
        if let hostPopover = hostingController.popoverPresentationController {
            hostPopover.sourceView = super.view
            let sheet = hostPopover.adaptiveSheetPresentationController
            sheet.detents = detents
            sheet.prefersGrabberVisible = prefersGrabberVisible
        }
        
        if presentedViewController == nil{
            present(hostingController, animated: true, completion: nil)
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
//        self.presentedViewController?.popoverPresentationController?.adaptiveSheetPresentationController.detents = detents
    }
}

extension View {
    func bottomSheet<Content: View>(isOpen: Binding<Bool>, backgroundColor: Color = Color.clear, prefersGrabberVisible: Bool = true, detents: [UISheetPresentationController.Detent] = [.custom(300)], content: @escaping () -> Content) -> some View {
        return self
            .background(
                BottomSheet(isPresent: isOpen, content: content(), backgroundColor: backgroundColor, prefersGrabberVisible: prefersGrabberVisible, detents: detents)
            )
    }
}


