//
//  UISheetView.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI
import UISheetPresentationControllerCustomDetent

extension View {
    
    func sheetView<Content: View>(isPresent: Binding<Bool>, uiHostingController: String,  @ViewBuilder content: @escaping () -> Content) -> some View {
        
        return self.background(SheetView(isPresent: isPresent, uiHostingController: uiHostingController, content: content()))
    }
}

struct SheetView<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresent: Bool
    let uiHostingController: String
    let content: Content
    
    let controller = UIViewController()
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        controller.view.backgroundColor = .clear
        return controller
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let hostingController = getController()
        
        if isPresent {
            
            uiViewController.present(hostingController, animated: true) {
                DispatchQueue.main.async {
                    self.isPresent.toggle()
                }
            }
        }
    }
    
    func getController () -> UIHostingController<Content> {
        switch uiHostingController {
            case "settingsHostingController":
                return SettingsHostingController(rootView: content)
            case "publicationHostingController":
                return PublicationHostingController(rootView: content)
            case "savePostHostingController":
                return SavePostHostingController(rootView: content)
            default:
                return UIHostingController(rootView: content)
        }
    }
}


class SettingsHostingController<Content: View>: UIHostingController<Content> {
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        
        if let presentationController = presentationController as? UISheetPresentationController {
            
            presentationController.detents = [
                .custom(549)
            ]
            
            presentationController.prefersGrabberVisible = false
        }
    }
}

class PublicationHostingController<Content: View>: UIHostingController<Content> {

    override func viewDidLoad() {
        view.backgroundColor = .clear

        if let presentationController = presentationController as? UISheetPresentationController {

            presentationController.detents = [
                .custom(440)
            ]

            presentationController.prefersGrabberVisible = false
        }
    }
}

class SavePostHostingController<Content: View>: UIHostingController<Content> {

    override func viewDidLoad() {
        view.backgroundColor = .clear

        if let presentationController = presentationController as? UISheetPresentationController {

            presentationController.detents = [
                .custom(280)
            ]

            presentationController.prefersGrabberVisible = false
        }
    }
}


struct PrefersGrabber: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 40)
            .fill(Color(hex: "#F2F2F2"))
            .frame(width: 40, height: 4)
            .padding(.top, 8)
    }
}
