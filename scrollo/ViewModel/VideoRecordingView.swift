//
//  SwiftUIView.swift
//  scrollo
//
//  Created by Artem Strelnik on 10.07.2022.
//

import SwiftUI
import Photos

struct CameraView : View {
    @Environment(\.presentationMode) var present: Binding<PresentationMode>
    @EnvironmentObject var mediaPost: AddMediaPostViewModel
    @StateObject var cameraController: CameraController = CameraController()
    @State var playAnimated: Bool = false
    @Binding var isPresentAddMediaPost: Bool
    
    var body : some View {
        
        ZStack(alignment: .topLeading) {
            
            GeometryReader {proxy in
                
                let size = proxy.size
                
                CameraPreview(size: size)
                    .environmentObject(cameraController )
            }
            //MARK: Camera controll
            .overlay(
                HStack{
                    Button(action: {
                        if cameraController.isRecording {

                            cameraController.stopRecording()

                            withAnimation(.spring()) {
                                playAnimated = false
                            }
                        } else {

                            cameraController.startRecording()

                            withAnimation(.spring()) {
                                playAnimated = true
                            }
                        }

                    }) {
                        ZStack {
                            Circle()
                                .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                                    playAnimated ? Color(hex: "#36DCD8") : Color(hex: "#FFFFFF"),
                                    playAnimated ? Color(hex: "#5B86E5") : Color(hex: "#FFFFFF")
                                    ]), startPoint: .leading, endPoint: .topTrailing),lineWidth: 9)
                                .background(Circle().frame(width: playAnimated ? 40 : 70, height: playAnimated ? 40 : 70).foregroundColor(Color.white))
                                .frame(width: playAnimated ? 100 : 70, height: playAnimated ? 100 : 70)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(playAnimated ? Color(hex: "#36DCD8") : Color.white)
                                .frame(width: 16, height: 16)
                        }
                    }
                    .buttonStyle(FlatLinkStyle())
                }
                    .offset(y: -90)
                ,alignment: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            //MARK: Back button
            Button(action: {
                mediaPost.pickedPhoto = [mediaPost.allPhotos[0][0]]
                mediaPost.selection = mediaPost.allPhotos[0][0]
                present.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 60)
            .offset(x: 5)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear(perform: cameraController.permission)
        .onReceive(cameraController.$didFinishRecordingTo, perform: { (finish) in
            if finish {
                if let url = cameraController.previewURL, let thumbnail = cameraController.thumbnail {
                    
                    mediaPost.pickedPhoto = [Asset(asset: PHAsset(), image: thumbnail, withAVCamera: url)]
                    
                    cameraController.thumbnail = nil
                    cameraController.previewURL = nil
                    cameraController.didFinishRecordingTo = false
                    
                    isPresentAddMediaPost.toggle()
                    present.wrappedValue.dismiss()
                }
            }
        })
        .alert(isPresented: $cameraController.alert.show) {
            Alert(title: Text(cameraController.alert.title), message: Text(cameraController.alert.message), dismissButton: .default(Text("Продолжить")))
        }
        
    }
    
}

struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}





