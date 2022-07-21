//
//  ImagePickerView.swift
//  scrollo
//
//  Created by Artem Strelnik on 08.07.2022.
//

import UIKit
import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    var complited: (UIImage) -> Void
    
    init(picker: ImagePickerView, complited: @escaping (UIImage) -> Void) {
        self.picker = picker
        self.complited = complited
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.complited(selectedImage)
        self.picker.isPresented.wrappedValue.dismiss()
        
    }
    
}


struct ImagePickerView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
    var complited: (UIImage) -> Void
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self, complited: self.complited)
    }
}


