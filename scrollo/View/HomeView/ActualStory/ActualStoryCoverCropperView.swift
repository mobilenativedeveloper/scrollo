//
//  ActualStoryCoverCropperView.swift
//  scrollo
//
//  Created by Artem Strelnik on 21.08.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActualStoryCoverCropperView: View {
    
    @State var image: UIImage?
    
    @State var imageSize: CGSize = CGSize()
    
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    
    let maxScale: CGFloat = 3.0
    let minScale: CGFloat = 1.0
    @State var scale: CGFloat = 1.0
    @State var lastValue: CGFloat = 1.0
    
    @State var cropperFrameRect: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
    
    @State private var imageCoordinate: CGPoint = CGPoint(x: 0, y: 0)
    @State private var cropFrameCoordinate: CGPoint = CGPoint(x: 0, y: 0)
    
    var body: some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .top)){
            if self.image != nil {
                let drag = DragGesture()
                            .onChanged { (value) in
                                self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                            }
                            .onEnded { value in
                                
                                print("imageCoordinate: \(imageCoordinate)")
                                print("cropFrameCoordinate: \(cropFrameCoordinate)")
                                print("currentPosition: \(self.currentPosition)")
                                
                                //MARK: Limit top leading angle
                                if self.imageCoordinate.x > self.cropFrameCoordinate.x && self.imageCoordinate.y > self.cropFrameCoordinate.y {
                                    withAnimation(.default) {
                                        print("Limit top leading angle")
                                        self.currentPosition.width = self.cropFrameCoordinate.x
                                        self.currentPosition.height = self.currentPosition.height - (self.imageCoordinate.y - self.cropFrameCoordinate.y)
                                    }
                                    self.newPosition = self.currentPosition
                                    return
                                }
                                //MARK: Limit top trailing angle
                                if self.imageCoordinate.x < (-self.cropFrameCoordinate.x) && self.imageCoordinate.y > self.cropFrameCoordinate.y {
                                    withAnimation(.default) {
                                        print("Limit top trailing angle")
                                        self.currentPosition.width = -self.cropFrameCoordinate.x
                                        self.currentPosition.height = self.currentPosition.height - (self.imageCoordinate.y - self.cropFrameCoordinate.y)
                                    }
                                    self.newPosition = self.currentPosition
                                    return
                                }
                                //MARK: Limit bottom trailing angle
                                if self.imageCoordinate.x < (-self.cropFrameCoordinate.x) && self.imageCoordinate.y > (-self.cropFrameCoordinate.y) {
                                    withAnimation(.default) {
                                        print("Limit bottom trailing angle")
                                        self.currentPosition.width = -self.cropFrameCoordinate.x
                                        self.currentPosition.height = -(self.currentPosition.height - (self.imageCoordinate.y - self.cropFrameCoordinate.y))
                                    }
                                    self.newPosition = self.currentPosition
                                    return
                                }
                                //MARK: Limit bottom leading angle
                                if self.imageCoordinate.x > self.cropFrameCoordinate.x && self.imageCoordinate.y > (-self.cropFrameCoordinate.y) {
                                    withAnimation(.default) {
                                        print("Limit bottom leading angle")
                                        self.currentPosition.width = self.cropFrameCoordinate.x
                                        self.currentPosition.height = -(self.currentPosition.height - (self.imageCoordinate.y - self.cropFrameCoordinate.y))
                                    }
                                    self.newPosition = self.currentPosition
                                    return
                                }
                                //MARK: Limit left edge
                                if self.imageCoordinate.x > self.cropFrameCoordinate.x {
                                    print("Limit left edge")
                                    withAnimation(.default) {
                                        self.currentPosition.width = self.cropFrameCoordinate.x
                                    }
                                    self.newPosition = self.currentPosition
                                    return
                                }
                                //MARK: Limit right edge
                                if self.imageCoordinate.x < (-self.cropFrameCoordinate.x) {
                                    print("Limit right edge")
                                    withAnimation(.default) {
                                        self.currentPosition.width = -self.cropFrameCoordinate.x
                                    }
                                    self.newPosition = self.currentPosition
                                    return
                                }
                                //MARK: Limit top edge
                                if self.imageCoordinate.y > self.cropFrameCoordinate.y {
                                    print("Limit top edge")
                                    withAnimation(.default) {
                                        self.currentPosition.height = self.currentPosition.height - (self.imageCoordinate.y - self.cropFrameCoordinate.y)
                                    }
                                    self.newPosition = self.currentPosition
                                    return
                                }
                                //MARK: Limit bottom edge
                                if self.imageCoordinate.y > (-self.cropFrameCoordinate.y) {
                                    print("Limit bottom edge")
                                    withAnimation(.default) {
                                        self.currentPosition.height = -(self.currentPosition.height - (self.imageCoordinate.y - self.cropFrameCoordinate.y))
                                    }
                                    self.newPosition = self.currentPosition
                                    return
                                }
                                
                            }
                
                let pinchScale = MagnificationGesture(minimumScaleDelta: 0.1)
                                    .onChanged { value in
                                        let resolvedDelta = value / self.lastValue
                                        self.lastValue = value
                                        let newScale = self.scale * resolvedDelta
                                        self.scale = min(self.maxScale, max(self.minScale, newScale))
                                    }
                                    .onEnded { value in
                                        self.lastValue = 1.0
                                    }
                ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                    BluredBackground()
                    CropImageView(currentPosition: currentPosition, scale: scale, image: self.image!, imageCoordinate: $imageCoordinate)
                    CropMask(cropperFrameRect: $cropperFrameRect, cropFrameCoordinate: $cropFrameCoordinate)
                }
                .coordinateSpace(name: "cropper.space")
                .gesture(drag)
//                .gesture(pinchScale)
            } else {
                ProgressView()
            }
            HeaderBar()
        }
        .clipped()
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            self.downloadImage(from: URL(string: "https://picsum.photos/1200/1200?random=1")!)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
}

private struct CropImageView: View {
    var currentPosition: CGSize
    var scale: CGFloat
    var image: UIImage
    @Binding var imageCoordinate: CGPoint
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .background(
                GeometryReader{reader in
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                        .position(x: 0, y: 0)
                }
            )
            .background(
                GeometryReader{reader -> Color in
                    let rect = reader.frame(in: .named("cropper.space"))
                    DispatchQueue.main.async {
                        imageCoordinate = rect.origin
                    }
                    return Color.clear
                }
            )
            .scaleEffect(scale)
            .offset(currentPosition)
            
    }
}

private struct BluredBackground: View {
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            WebImage(url: URL(string: "https://picsum.photos/200/300?random=1")!)
                .resizable()
            VisualEffectView(effect: UIBlurEffect(style: .light))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

private struct CropMask: View {
    @Binding var cropperFrameRect: CGRect
    @Binding var cropFrameCoordinate: CGPoint
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.7))
            .overlay(
                GeometryReader{reader in
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                        .position(x: cropFrameCoordinate.x, y: cropFrameCoordinate.y)
                }
            )
            .mask(
                CropFrameOverlay(cropperFrameRect: $cropperFrameRect, cropFrameCoordinate: $cropFrameCoordinate)
                .fill(style: FillStyle(eoFill: true))
            )
    }
}


private struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

private struct CropFrameOverlay: Shape {
    @Binding var cropperFrameRect: CGRect
    @Binding var cropFrameCoordinate: CGPoint
    func path(in rect: CGRect) -> Path {
        DispatchQueue.main.async {
            cropFrameCoordinate = CGPoint(
                x: (rect.width / 2) - ((rect.width - 40) / 2),
                y: (rect.height / 2) - ((rect.width - 40) / 2)
            )
        }
        var shape = Rectangle().path(in: CGRect(
                x: 0,
                y: 0,
                width: rect.width,
                height: rect.height
            ))
            shape.addPath(Circle().path(in: CGRect(
                x: (rect.width / 2) - ((rect.width - 40) / 2),
                y: (rect.height / 2) - ((rect.width - 40) / 2),
                width: rect.width - 40,
                height: rect.width - 40
            )))
        return shape
    }
}

private struct HeaderBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("circle.left.arrow")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .aspectRatio(contentMode: .fill)
            }
            Spacer(minLength: 0)
            Text("Редактировать обложку")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .textCase(.uppercase)
                .foregroundColor(Color(hex: "#2E313C"))
            Spacer(minLength: 0)
            Button(action: {

            }) {
                Image("circle.right.arrow")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .aspectRatio(contentMode: .fill)
            }
        }
        .padding(.horizontal, 23)
        .padding(.vertical)
        .background(Color.white)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
