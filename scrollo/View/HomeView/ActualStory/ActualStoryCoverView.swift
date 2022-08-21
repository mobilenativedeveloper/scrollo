//
//  ActualStoryCoverView.swift
//  scrollo
//
//  Created by Artem Strelnik on 21.08.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActualStoryCoverView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let characterLimit: Int = 15
    @State var name: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
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
                Text("Название")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(Color(hex: "#2E313C"))
                Spacer(minLength: 0)
                Button(action: {}) {
                    Image("circle.right.arrow")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fill)
                }
            }
            .padding(.horizontal, 23)
            .padding(.bottom)
            
            VStack {
                CoverView()
                    .padding(.top, 100)
                    .padding(.bottom)
                TextField("Актуальное", text: $name)
                    .font(Font.headline.weight(.bold))
                    .frame(width: 200)
                    .multilineTextAlignment(.center)
                    .onReceive(name.publisher.collect()) {
                        name = String($0.prefix(15))
                    }
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

private struct CoverView: View {
    var body: some View {
        VStack {
            ZStack {
                
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 150, height: 150)
                Circle()
                    .fill(Color.white)
                    .frame(width: 147, height: 147)
                WebImage(url: URL(string: "https://picsum.photos/200/300?random=1")!)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .clipShape(Circle())
                    .frame(width: 144, height: 144)
                    .background(Color.gray.opacity(0.2).clipShape(Circle()))
                    .scaledToFit()
                
            }
            Button(action: {}) {
                Text("Редактировать обложку")
            }
        }
    }
}
