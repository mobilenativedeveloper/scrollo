//
//  AddStoryView.swift
//  scrollo
//
//  Created by Artem Strelnik on 19.08.2022.
//

import SwiftUI
import Photos

struct AddStoryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var addStoryController: AddStoryViewModel = AddStoryViewModel()
    @State var mediaAlbum: Bool = false
    let data: [Int] = [1,2,3,4,5,6,7,8]
    private let columns = 3
    private let size = (UIScreen.main.bounds.width / 3) - 12
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            HStack(alignment: .center, spacing: 0) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("circle_close_white")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fill)
                }
                Spacer(minLength: 0)
                Text("добавить историю")
                    .font(.custom(GothamBold, size: 20))
                    .foregroundColor(.white)
                Spacer(minLength: 0)
                Image("circle_right_arrow_white")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .aspectRatio(contentMode: .fill)
            }
            .padding(.horizontal, 23)
            .background(Color(hex: "#1F2128"))
            
            PreviewStoryView(mediaAlbum: $mediaAlbum)
                .environmentObject(addStoryController)
            
            if addStoryController.loadAssets {
                ScrollView(showsIndicators: false) {
                    makeGrid()
                }
                Spacer()
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
    }
    
    private func makeGrid() -> some View {
        let count = addStoryController.assets.count
        let rows = count / columns + (count % columns == 0 ? 0 : 1)
            
        return VStack(alignment: .leading, spacing: 9) {
            ForEach(0..<rows) { row in
                HStack(spacing: 9) {
                    ForEach(0..<self.columns) {column in
                        let index = row * self.columns + column
                        if index < count {
                            GridThumbnailGallery(uiImage: addStoryController.assets[index], size: size)
                        } else {
                            AnyView(EmptyView())
                                .frame(width: size, height: 180)
                        }
                    }
                }
            }
        }
        .padding(.top, 10)
    }
}

private struct GridThumbnailGallery : View {
    var uiImage: UIImage
    var size: CGFloat
    var body : some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: 180)
            .cornerRadius(8)
            .clipped()
    }
}

private struct PreviewStoryView : View {
    @EnvironmentObject var addStoryController: AddStoryViewModel
    @Binding var mediaAlbum: Bool
    var body : some View {
        
        ZStack(alignment: .bottom) {
            
            ZStack(alignment: .center) {
                
                Color(hex: "#1F2128")
                
                Image("add_story_placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 188, height: 188)
                
                
            }
            .frame(height: UIScreen.main.bounds.height / 2.4)
            
            HStack(spacing: 0) {
                PreviewStoryAlbumPickerView()
                    .offset(x: 18, y: -21)
                    .environmentObject(addStoryController)
                Spacer()
                HStack {

                    Image("group")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .aspectRatio(contentMode: .fit)
                    Text("выбрать несколько")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 5)
                .background(Color(hex: "#1F2128").opacity(0.7))
                .cornerRadius(16)
                .offset(x: -18, y: -21)
            }
        }
    }
}

private struct PreviewStoryAlbumPickerView : View {
    @EnvironmentObject var addStoryController: AddStoryViewModel
    
    var body : some View {
        HStack {
            Picker("ru", selection: $addStoryController.selectedAlbum) {
                ForEach(0..<addStoryController.albums.count, id: \.self) {index in
                    if let album = addStoryController.albums[index] {
                        Text("\(self.getAlbumTitle(album: album))")
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                            .colorMultiply(.white)
                            .textCase(.uppercase)
                            .padding(.vertical, 15)
                    }
                }
            }
            .foregroundColor(.white)
            .colorMultiply(.black).colorInvert()
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            .onChange(of: addStoryController.selectedAlbum) { _ in
                addStoryController.getThumbnailAssetsFromAlbum()
            }
            Image(systemName: "chevron.down")
                .font(.system(size: 15))
                .foregroundColor(.white)
        }
    }
    
    func getAlbumTitle (album: PHAssetCollection) -> String {
        switch album.localizedTitle?.lowercased() {
            case "recents":
                return "Недавние"
            default:
                return album.localizedTitle!
        }
    }
}
