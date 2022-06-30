//
//  UIAVPlayerControllerRepresented.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//


import SwiftUI
import AVKit

struct UIAVPlayerControllerRepresented : UIViewControllerRepresentable {
    var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
