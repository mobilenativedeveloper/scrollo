//
//  ActualStoryCoverCropperView.swift
//  scrollo
//
//  Created by Artem Strelnik on 21.08.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActualStoryCoverCropperView: View {
    @StateObject var cropperDelegate: CropperDelegate = CropperDelegate()
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            ZStack(alignment: .center){
                if cropperDelegate.originalImage == nil {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    GeometryReader{proxy in
                        ZStack {
                            BluredBackground(image: cropperDelegate.originalImage!)
                            ScrollView.init([.vertical,.horizontal], showsIndicators: false) {
                                Image(uiImage: cropperDelegate.originalImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .scaleEffect(cropperDelegate.scale)
                                    .gesture(cropperDelegate.scaleController())
                            }
                            .frame(width: cropperDelegate.cropSize.width, height: cropperDelegate.cropSize.height, alignment: .center)
                            .clipShape(Circle())
                        }
                        .frame(width:proxy.size.width,height: proxy.size.height)
                    }
                }
            }
            HeaderBar()
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            cropperDelegate.downloadImage(from: URL(string: "https://picsum.photos/700/700.jpg")!) { image in
                cropperDelegate.originalImage = image
            }
        }
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
        .padding(.bottom)
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(VisualEffectView(effect: UIBlurEffect(style: .light)))
    }
}

private struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

private struct BluredBackground: View {
    var image: UIImage
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Image(uiImage: image)
                .resizable()
            VisualEffectView(effect: UIBlurEffect(style: .light))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

class CropperDelegate: ObservableObject {
    @Published var originalImage: UIImage?
    
    @Published var scale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    @Published var maximumScale: CGFloat = 2.0
    @Published var minimumScale: CGFloat = 1.0
    
    @Published var cropSize: CGSize = CGSize(
        width: UIScreen.main.bounds.width,
        height: UIScreen.main.bounds.width
    )
    
    func scaleController () -> some Gesture {
        return MagnificationGesture(minimumScaleDelta: 0.1)
            .onChanged { value in
                let resolvedDelta = value / self.lastScale
                self.lastScale = value
                let newScale = self.scale * resolvedDelta
                self.scale = min(self.maximumScale, max(self.minimumScale, newScale))
            }.onEnded { value in
                self.lastScale = 1.0
            }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, onDownloaded: @escaping (UIImage) -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                onDownloaded(UIImage(data: data)!)
            }
        }
    }
}
