//
//  SelectAttachmentsView.swift
//  scrollo
//
//  Created by Artem Strelnik on 15.09.2022.
//

import SwiftUI

struct SelectAttachmentsView: View {
    @StateObject var photos: AttachmentsViewModel = AttachmentsViewModel()
    @Binding var isPresent: Bool
    @State var offset: CGFloat = 900
    @State var opacity: CGFloat = 0
    let height: CGFloat = 700
    let bounceOffset: CGFloat = 200
    
    private let columns = 3
    private let size = (UIScreen.main.bounds.width / 3)
    
    let sendMedia: ([AssetModel]) -> Void
    
    var body: some View {
        if isPresent {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
                Color.black.opacity(opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            self.opacity = 0
                            self.offset = 900
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isPresent = false
                            }
                        }
                    }
                GeometryReader{reader in
                    VStack(spacing: 0){
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(hex: "F2F2F2"))
                            .frame(width: 40, height: 4)
                            .padding(.top)
                            .padding(.bottom, photos.permissionStatus == .denied ? 25 : 10)
                        
                        // If permission denide
                        if photos.permissionStatus == .denied{
                            Text("Получите доступ к своим фото и видео из Scrollo")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .frame(width: 300)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 40)
                            
                            HStack(alignment: .top){
                                Image(systemName: "info.circle")
                                    .font(.title)
                                    .frame(width: 30, height: 30)
                                Text("Вы сможете получить доступ ко всем своим фото из Scrollo или выбрать несколько из них вручную.")
                                    .font(.system(size: 13))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .frame(width: 350)
                            .padding(.bottom)
                            HStack(alignment: .top){
                                Image(systemName: "checkmark.shield")
                                    .font(.title)
                                    .frame(width: 30, height: 30)
                                Text("Вы сами решаете, какими фото и видео делиться с другими.")
                                    .font(.system(size: 13))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .frame(width: 350)
                            .padding(.bottom)
                            HStack(alignment: .top){
                                Image(systemName: "photo")
                                    .font(.system(size: 14))
                                    .frame(width: 30, height: 30)
                                Text("Делиться контентом в Scrollo проще, когда у вас есть доступ ко всей фотопленке.")
                                    .font(.system(size: 13))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .frame(width: 350)
                            .padding(.bottom)
                            
                            Text("Выберите Разрешить доступ ко всем фото, чтобы открыть вашу фотопленку из приложения Scrollo.")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .frame(width: 290)
                                .multilineTextAlignment(.center)
                        }
                        // Else
                        else{
                            Button(action:{}){
                                HStack{
                                    Text("Недавние")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12))
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.bottom, 15)
                            .overlay(
                                Rectangle()
                                    .fill(Color(hex: "F2F2F2"))
                                    .frame(width: UIScreen.main.bounds.width, height: 1)
                                ,alignment: .bottom
                            )
                            
                            if photos.load{
                                ScrollView(showsIndicators: false){
                                    VStack(spacing: 1){
                                        makeGrid()
                                        Spacer(minLength: bounceOffset + 50)
                                    }
                                }
                            }
                            else{
                                ProgressView()
                            }
                        }
                        
                    
                    }
                    .frame(width: reader.size.width)
                }
                .frame(height: height + bounceOffset)
                .background(Color.white)
                .clipShape(CustomCorner(radius: 20, corners: [.topLeft, .topRight]))
                .overlay(alignment: .bottom){
                    if photos.permissionStatus == .denied || photos.selectedPhotos.count > 0{
                        HStack{
                            Button(action: {
                                if photos.permissionStatus == .denied{
                                    photos.openAppSettings()
                                } else {
                                    sendMedia(photos.selectedPhotos)
                                    withAnimation(.easeInOut){
                                        self.opacity = 0
                                        self.offset = 900
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            isPresent = false
                                        }
                                    }
                                }
                            }) {
                                Text(photos.permissionStatus == .denied ? "Перейти в настройки" : "Продолжить")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .frame(width: UIScreen.main.bounds.width - 40)
                            .background(Color(hex: "#5B86E5").clipShape(RoundedRectangle(cornerRadius: 10)))
                        }
                            .offset(y: -(bounceOffset + 50))
                    }
                }
                .offset(y: offset + bounceOffset)
                .gesture(DragGesture().onChanged(onChange(value: )).onEnded(onEnd(value:)))
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear{
                withAnimation(.easeInOut){
                    self.opacity = 0.5
                    self.offset = .zero
                }
            }
        } else {
            Color.clear.frame(height: 0)
        }
    }
    
    func onChange(value: DragGesture.Value) {
        
        if !(value.translation.height < -(bounceOffset / 2)) {
            self.offset = value.translation.height
        }
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(.easeInOut) {
            if value.translation.height > ((height + bounceOffset) / 3) {
                self.offset = height + bounceOffset
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.opacity = 0
                    self.offset = 900
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPresent = false
                    }
                }
            }
            else if (value.translation.height < (offset + bounceOffset)) {
                self.offset = 0
            }
            else {
                self.offset = 0
            }
        }
    }
    
    private func makeGrid() -> some View {
        let count = photos.assets.count
        let rows = count / columns + (count % columns == 0 ? 0 : 1)
            
        return VStack(alignment: .leading, spacing: 1) {
            ForEach(0..<rows) { row in
                HStack(spacing: 1) {
                    ForEach(0..<self.columns) {column in
                        let index = row * self.columns + column
                        if index < count {
                            GridThumbnailGallery(asset: photos.assets[index], size: size)
                                .environmentObject(photos)
                        } else {
                            AnyView(EmptyView())
                                .frame(width: size, height: size)
                        }
                    }
                }
            }
        }
    }
}


private struct GridThumbnailGallery : View {
    @EnvironmentObject var photos: AttachmentsViewModel
    var asset: AssetModel
    var size: CGFloat
    var body : some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottomLeading) {
                Image(uiImage: asset.thumbnail)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .contentShape(Rectangle())
                    .clipped()
                    
                if asset.asset.mediaType == .video {
                    Text(photos.getVideoDuration(asset: asset))
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .offset(x: 6, y: -9)
                }
            }
            
            ZStack {
                
                let number = photos.getNumber(asset: asset)
                
                Circle()
                    .strokeBorder(Color.white,lineWidth: 1)
                    .background(Circle().foregroundColor(photos.checkSelect(asset: asset) ? Color(hex: "#66b0ff") : Color.white.opacity(0.3)))
                    .frame(width: 20, height: 20)
                
                if number != -1 {
                    
                    Text("\(number)")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 20, height: 20)
            .offset(x: -8, y: 8)
        }
        
        .onTapGesture {
            photos.pickPhoto(asset: asset)
        }
    }
}
