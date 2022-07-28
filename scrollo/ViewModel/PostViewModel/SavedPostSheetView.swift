//
//  SavedPostSheetView.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct SavedPostSheetView: View {
    @EnvironmentObject var savePostController: SavePostViewModel
    @StateObject var albumsController: AlbumsViewModel = AlbumsViewModel()
    @Binding var post: PostModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white
            
            VStack {
                Text("Сохранить в")
                    .fontWeight(.bold)
                    .padding(.vertical)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    if albumsController.status == .success {
                        HStack(spacing: 20) {
                            ForEach(0..<albumsController.albums.count, id: \.self) {index in
                                Button(action: {
                                    savePostController.saveMediaPost(postId: post.id, albumId: albumsController.albums[index].id, albumName: albumsController.albums[index].name) {
                                        post.inSaved = true
                                        savePostController.isPresentListAbums.toggle()
                                    }
                                }) {
                                    VStack {
                                        if albumsController.albums[index].preview.count > 1 {
                                            if let path = albumsController.albums[index].preview[0] {
                                                WebImage(url: URL(string: "\(API_URL)/uploads/\(path)"))
                                                    .resizable()
                                                    .frame(width: 90, height: 90)
                                                    .cornerRadius(6)
                                            }
                                        } else {
                                            Color(hex: "#efefef")
                                                .cornerRadius(6)
                                                .frame(width: 90, height: 90)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .stroke(Color(hex: "#e7e7e7"), lineWidth: 1)
                                                )
                                        }
                                        Text(albumsController.albums[index].name)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .ignoresSafeArea()
    }
}


//struct SavedPostSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedPostSheetView()
//    }
//}
