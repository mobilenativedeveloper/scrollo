//
//  SavedMediaAlbumView.swift
//  scrollo
//
//  Created by Artem Strelnik on 08.07.2022.
//

import SwiftUI

struct SavedMediaAlbumView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var savedPosts: SavedPostsViewModel = SavedPostsViewModel()
    @State var albumCotroller: AddAlbumViewModel = AddAlbumViewModel()
    @State var isOptions: Bool = false
    @State var selectedTab: String = "photo"
    var albumId: String
    var headerTitle: String
    
    let width = (UIScreen.main.bounds.width / 3) - 16
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("comments_back")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
                Spacer(minLength: 0)
                Text("\(headerTitle)")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(Color(hex: "#1F2128"))
                Spacer(minLength: 0)
                Button(action: {
                    isOptions.toggle()
                }) {
                    Image(systemName: "pencil.line")
                        .resizable()
                        .foregroundColor(.black)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.top)
            .padding(.horizontal)
            .padding(.bottom)
            HStack(spacing: 0) {
                Button(action: {
                    self.selectedTab = "photo"
                }) {
                    Rectangle()
                        .stroke(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1))
                        .overlay(
                            self.getTabImage(active: "profile_media_post_tab_active", inactive: "profile_media_post_tab_inactive", selection: self.selectedTab == "photo")
                        )
                }
                Button(action: {
                    self.selectedTab = "video"
                }) {
                    Rectangle()
                        .stroke(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1))
                        .overlay(
                            self.getTabImage(active: "camera_active", inactive: "camera_inactive", selection: self.selectedTab == "video")
                        )
                }
            }
            .frame(height: 55)
            ScrollView {
                if savedPosts.savedMediaPostsLoad {
                    VStack(alignment: .leading, spacing: 0) {
                        PostCompositionView(posts: $savedPosts.savedMediaPosts)
                    }
                    .padding(.horizontal, 26)
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
        }
        .confirmationDialog("", isPresented: $isOptions, actions: {
            Button("Удалить подборку", role: .destructive) {
                albumCotroller.removeAlbum(albumId: albumId)
            }
        })
//        .actionSheet(isPresented: $showLocationOptions) {
//            ActionSheet(title: Text(""), message: Text("Select a location"), buttons: [
//
//            ,
//            .default(Text(location2)) {  },
//            .default(Text(location3)) {  },
//            .default(Text(location4)) {  },
//            .default(Text(location5)) {  },
//            .destructive(Text("Отмена")){
//
//                }
//            ])
//        }
        .onAppear(perform: {
            savedPosts.getSavedMediaPosts(albumId: albumId)
        })
    }
    
    @ViewBuilder
    private func getTabImage(active: String, inactive: String, selection: Bool) -> some View {
        let image: String = selection ? active : inactive
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 22, height: 22)
    }
}

//struct SavedMediaAlbumView_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedMediaAlbumView()
//    }
//}
