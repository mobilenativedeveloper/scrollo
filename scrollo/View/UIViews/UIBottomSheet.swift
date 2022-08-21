//
//  UIBottomSheet.swift
//  scrollo
//
//  Created by Artem Strelnik on 20.08.2022.
//

import SwiftUI
import UISheetPresentationControllerCustomDetent


extension View {

    func sheetView<Content: View>(
        isPresent: Binding<Bool>,
        backgroundColor: Color,
        prefersGrabberVisible: Bool,
        detents: [UISheetPresentationController.Detent] ,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {

        return self.background(
            SheetView(
                isPresent: isPresent,
                content: content(),
                backgroundColor: backgroundColor,
                prefersGrabberVisible: prefersGrabberVisible,
                detents: detents
            )
        )
    }
}

struct SheetView<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresent: Bool
    var content: Content
    var backgroundColor: Color
    var prefersGrabberVisible: Bool
    var detents: [UISheetPresentationController.Detent]

    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }


    func makeUIViewController(context: Context) -> UIViewController {

        controller.view.backgroundColor = .clear
        return controller
    }


    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let hostingController = SheetHostingController(
            content: content,
            backgroundColor: backgroundColor,
            prefersGrabberVisible: prefersGrabberVisible,
            detents: detents
        )
        

        if isPresent {
            uiViewController.present(hostingController, animated: true) {
                DispatchQueue.main.async {
                    self.isPresent.toggle()
                }
            }
        }
    }
    
    
    class SheetHostingController<Content: View>: UIHostingController<Content> {
        var backgroundColor: Color
        var prefersGrabberVisible: Bool
        var detents: [UISheetPresentationController.Detent]
        
        init (
            content: Content,
            backgroundColor: Color,
            prefersGrabberVisible: Bool,
            detents: [UISheetPresentationController.Detent]
        ) {
            self.backgroundColor = backgroundColor
            self.prefersGrabberVisible = prefersGrabberVisible
            self.detents = detents
            
            super.init(rootView: content)
        }
        
        @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            view.backgroundColor = UIColor(backgroundColor)

            if let presentationController = presentationController as? UISheetPresentationController {

                presentationController.detents = detents

                presentationController.prefersGrabberVisible = prefersGrabberVisible
            }
        }
    }

    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var parent: SheetView
        init(_ parent: SheetView) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            if parent.isPresent{
                parent.isPresent = false
            }
        }
    }
}


//struct BottomSheet<Content: View>: UIViewControllerRepresentable {
//
//    @Binding var isPresent: Bool
//    var content: Content
//    var backgroundColor: Color
//    var prefersGrabberVisible: Bool
//    var detents: [UISheetPresentationController.Detent]
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> CustomSheetViewController<Content> {
//        let vc = CustomSheetViewController(coordinator: context.coordinator, detents: detents, prefersGrabberVisible: prefersGrabberVisible, backgroundColor: backgroundColor)
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: CustomSheetViewController<Content>, context: Context) {
//        if isPresent{
//            uiViewController.presentModalView(content: content)
//        } else{
//            uiViewController.dismissModalView()
//        }
//    }
//
//    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
//        var parent: BottomSheet
//        init(_ parent: BottomSheet) {
//            self.parent = parent
//        }
//
//        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//            if parent.isPresent{
//                parent.isPresent = false
//            }
//        }
//    }
//}
//
//
//class CustomSheetViewController<Content: View>: UIViewController {
//    var coordinator: BottomSheet<Content>.Coordinator
//    var detents : [UISheetPresentationController.Detent]
//    var backgroundColor: Color
//    var prefersGrabberVisible: Bool
//
//    init(coordinator: BottomSheet<Content>.Coordinator, detents : [UISheetPresentationController.Detent], prefersGrabberVisible: Bool, backgroundColor: Color) {
//        self.coordinator = coordinator
//        self.detents = detents
//        self.prefersGrabberVisible = prefersGrabberVisible
//        self.backgroundColor = backgroundColor
//        super.init(nibName: nil, bundle: .main)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func dismissModalView(){
//        dismiss(animated: true, completion: nil)
//    }
//
//    func presentModalView(content: Content){
//
//        let hostingController = UIHostingController(rootView: content)
//
//        hostingController.modalPresentationStyle = .popover
//        hostingController.presentationController?.delegate = coordinator as UIAdaptivePresentationControllerDelegate
//        hostingController.view.backgroundColor = UIColor(backgroundColor)
//        hostingController.modalTransitionStyle = .coverVertical
//
//        if let hostPopover = hostingController.popoverPresentationController {
//            hostPopover.sourceView = super.view
//            let sheet = hostPopover.adaptiveSheetPresentationController
//            sheet.detents = detents
//            sheet.prefersGrabberVisible = prefersGrabberVisible
//        }
//
//        if presentedViewController == nil{
//            present(hostingController, animated: true, completion: nil)
//        }
//    }
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        self.presentedViewController?.popoverPresentationController?.adaptiveSheetPresentationController.detents = detents
//    }
//}
//
//extension View {
//    func bottomSheet<Content: View>(isOpen: Binding<Bool>, backgroundColor: Color = Color.clear, prefersGrabberVisible: Bool = true, detents: [UISheetPresentationController.Detent] = [.custom(300)], @ViewBuilder content: @escaping () -> Content) -> some View {
//        return self
//            .background(
//                BottomSheet(isPresent: isOpen, content: content(), backgroundColor: backgroundColor, prefersGrabberVisible: prefersGrabberVisible, detents: detents)
//            )
//    }
//}
//
//
