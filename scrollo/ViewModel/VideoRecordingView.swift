//
//  SwiftUIView.swift
//  scrollo
//
//  Created by Artem Strelnik on 10.07.2022.
//

import SwiftUI
import AVFoundation
import Photos
import AVKit

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

class CameraController: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate  {
    
    @Published var alert: AlertModel = AlertModel(title: "", message: "", show: false)
    @Published var session = AVCaptureSession()
    @Published var output = AVCaptureMovieFileOutput ()
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    @Published var isRecording: Bool = false
    @Published var recordedURLs: [URL] = []
    @Published var previewURL: URL?
    @Published var showPreview: Bool = false
    
    @Published var thumbnail: UIImage?
    
    @Published var didFinishRecordingTo: Bool = false
    
    func permission () -> Void {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
            case .authorized:
                beginConfiguration()
                return
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (status) in
                    if status {
                        
                        self.beginConfiguration()
                    }
                }
            case .denied:
                self.alert = AlertModel(title: "Ошибка", message: "Нет доступа к камере", show: true)
                return
            default: return
        }
    }
    
    func beginConfiguration () -> Void {
        
        do {
            
            self.session.beginConfiguration()
            
            let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let videoInput = try AVCaptureDeviceInput(device: cameraDevice!)
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            if self.session.canAddInput(videoInput) && self.session.canAddInput(audioInput ){
                self.session.addInput(videoInput)
                self.session.addInput(audioInput)
            }
            
            if self.session.canAddOutput(output) {
                self.session.addOutput(output)
            }
            
            self.session.commitConfiguration()
            
        } catch {
            print("CAMERA ERROR", error.localizedDescription)
        }
    }
    
    func startRecording () {
        
        let tempURL = NSTemporaryDirectory() + "\(Date()).mov"
        output.startRecording(to: URL(fileURLWithPath: tempURL), recordingDelegate: self)
        
        isRecording = true
    }
    
    func stopRecording () {
        
        output.stopRecording()
        
        isRecording = false
    }
    
    func fileOutput (_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        DispatchQueue.global().async {
            let asset = AVAsset(url: outputFileURL)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            
            let tumbnailTime = CMTimeMake(value: 7, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: tumbnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    self.thumbnail = thumbImage
                    self.previewURL = outputFileURL
                    self.didFinishRecordingTo = true
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
    }
}

private struct CameraPreview : UIViewRepresentable {
    
    @EnvironmentObject var cameraController : CameraController
    var size: CGSize
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView()
        
        cameraController.preview = AVCaptureVideoPreviewLayer(session: cameraController.session)
        cameraController.preview.frame.size = size
        
        cameraController.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraController.preview)
        
        cameraController.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}



