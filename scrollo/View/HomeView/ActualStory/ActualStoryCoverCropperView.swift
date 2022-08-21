//
//  ActualStoryCoverCropperView.swift
//  scrollo
//
//  Created by Artem Strelnik on 21.08.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActualStoryCoverCropperView: View {
    var body: some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .top)){
            ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                BluredBackground()
                CropImageView()
                CropMask()
            }
            HeaderBar()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
}

private struct CropImageView: View {
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            WebImage(url: URL(string: "https://picsum.photos/200/300?random=1")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(width: 300, height: 300)
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
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.7))
            .mask(
                CropFrameOverlay()
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
    func path(in rect: CGRect) -> Path {
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
