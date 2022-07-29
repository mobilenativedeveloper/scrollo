//
//  SavedView.swift
//  scrollo
//
//  Created by Artem Strelnik on 08.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct SavedView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var savedPosts: SavedPostsViewModel = SavedPostsViewModel()
    
    @StateObject var albumsController: AlbumsViewModel = AlbumsViewModel(composition: true)
    @StateObject var addAlbumController: AddAlbumViewModel = AddAlbumViewModel()
    
    @State private var selection: String = "Медиа"
    private let tabs: [String] = ["Медиа", "Посты"]
    let savedItemSize: CGFloat = (UIScreen.main.bounds.width / 2) - 26 - 9
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("circle_close")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
                Spacer(minLength: 0)
                Text("сохранённое")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(Color(hex: "#1F2128"))
                Spacer(minLength: 0)
                Button(action: {
                    addAlbumController.isAddAlbum.toggle()
                }) {
                    Image("blue_circle_outline_plus")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.bottom)
            .padding(.horizontal)
            self.tabsHeader()
            VStack {
                TabView(selection: self.$selection) {
                    VStack {
                        if albumsController.status == .success {
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(spacing: 0) {
                                    ForEach(0..<albumsController.albumsComposition.count, id: \.self){index in
                                        ForEach(0..<albumsController.albumsComposition[index].count, id: \.self) {_ in
                                            
                                            HStack(spacing: 0) {
                                                if albumsController.albumsComposition[index].count >= 1 {
                                                    SavedItem(album: albumsController.albumsComposition[index][0])
                                                }
                                                Spacer(minLength: 0)
                                                if albumsController.albumsComposition[index].count == 2 {
                                                    SavedItem(album: albumsController.albumsComposition[index][1])
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 26)
                                .padding(.top, 10)
                            }
                        }
                        if albumsController.status == .load {
                            ProgressView()
                        }
                    }
                    .tag("Медиа")
                    VStack {
                        if savedPosts.savedTextPostsLoad {
                            ScrollView {
                                ForEach(0..<savedPosts.savedTextPosts.count, id: \.self) {index in
                                    UIViewTextPost(post: $savedPosts.savedTextPosts[index])
                                }
                            }
                        } else {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .tag("Посты")
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: Alignment(horizontal: .leading, vertical: .top))
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .alert(isPresented: $albumsController.alert.show) {
            Alert(
                title: Text(albumsController.alert.title),
                message: Text(albumsController.alert.message),
                dismissButton: .default(Text("Продолжить"), action: {
                    albumsController.alert = AlertModel(title: "", message: "", show: false)
                    if albumsController.status == .error {
                        albumsController.status == .initial
                    }
                })
            )
        }
        .onAppear(perform: savedPosts.getSavedTextPosts)
        .onReceive(albumsController.$status) { (value) in
            if value == .error {
                albumsController.alert = AlertModel(title: "Ошибка", message: "Произошла ошибка, попробуйе еще раз.", show: true)
            }
        }
        .fullScreenCover(isPresented: $addAlbumController.isAddAlbum, content: {
            AddAlbumView().environmentObject(addAlbumController)
        })
    }
    @ViewBuilder
    private func tabsHeader() -> some View {
        HStack(spacing: 0) {
            ForEach(0..<self.tabs.count, id: \.self) {index in
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    Button(action: {
                        self.selection = self.tabs[index]
                    }) {
                        Text(self.tabs[index])
                            .font(.custom(self.selection == self.tabs[index] ? GothamBold : GothamBook, size: 13))
                            .textCase(.uppercase)
                            .foregroundColor(Color(hex: self.selection == self.tabs[index] ? "#5B86E5" :  "#333333"))
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / CGFloat(self.tabs.count) - 32))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "#5B86E5").opacity(self.selection == self.tabs[index] ? 1 : 0))
                        .frame(width: (UIScreen.main.bounds.width / CGFloat(self.tabs.count) - 32), height: 3)
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func SavedItem(album: AlbumModel) -> some View {
        NavigationLink(destination: SavedMediaAlbumView(albumId: album.id, headerTitle: album.name).ignoreDefaultHeaderBar) {
            VStack {
                VStack(spacing: 1) {
                    HStack(spacing: 1) {
                        if album.preview.count >= 1 {
                            WebImage(url: URL(string: "\(API_URL)/uploads/\(album.preview[0])"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: savedItemSize / 2, height: savedItemSize / 2)
                                .cornerRadius(6)
                        } else {
                            Color(hex: "#efefef")
                                .frame(width: savedItemSize / 2, height: savedItemSize / 2)
                                .cornerRadius(6)
                        }
                        
                        if album.preview.count >= 2 {
                            WebImage(url: URL(string: "\(API_URL)/uploads/\(album.preview[1])"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: savedItemSize / 2, height: savedItemSize / 2)
                                .cornerRadius(6)
                        } else {
                            Color(hex: "#efefef")
                                .frame(width: savedItemSize / 2, height: savedItemSize / 2)
                                .cornerRadius(6)
                        }
                    }
                    HStack(spacing: 1) {
                        if album.preview.count >= 3 {
                            WebImage(url: URL(string: "\(API_URL)/uploads/\(album.preview[2])"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: savedItemSize / 2, height: savedItemSize / 2)
                                .cornerRadius(6)
                        } else {
                            Color(hex: "#efefef")
                                .frame(width: savedItemSize / 2, height: savedItemSize / 2)
                                .cornerRadius(6)
                        }
                        
                        if album.preview.count >= 4 {
                            WebImage(url: URL(string: "\(API_URL)/uploads/\(album.preview[3])"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: savedItemSize / 2, height: savedItemSize / 2)
                                .cornerRadius(6)
                        } else {
                            Color(hex: "#efefef")
                                .frame(width: savedItemSize / 2, height: savedItemSize / 2)
                                .cornerRadius(6)
                        }
                    }
                    
                }
                .frame(width: savedItemSize, height: savedItemSize)
                .clipped()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 1)
                        )
                        .frame(width: savedItemSize + 12, height: savedItemSize + 12)
                        .foregroundColor(Color(hex: "#909090"))
                )
                .padding(.bottom, 10)
                Text(album.name)
                    .font(.custom(GothamBold, size: 14))
                    .foregroundColor(Color(hex: "#2E313C"))
                    .padding(.bottom, 10)
                
            }
            .padding(.bottom, 10)
        }
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
    }
}

struct AddAlbumView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var addAlbumController: AddAlbumViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    if addAlbumController.status != .load {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image("circle_close")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
                Spacer(minLength: 0)
                Text("Новый альбом")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(Color(hex: "#1F2128"))
                Spacer(minLength: 0)
                Button(action: {
                    if addAlbumController.status != .load {
                        addAlbumController.createAlboum()
                    }
                }) {
                    if addAlbumController.status == .load {
                        ProgressView()
                            .frame(width: 24, height: 24)
                    } else {
                        Image("blue_circle_outline_plus")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(.bottom)
            .padding(.horizontal)
            ScrollView(showsIndicators: false) {
                HStack(spacing: 0) {
                    Text("Название")
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    Spacer()
                }
                TextField("Название альбома", text: $addAlbumController.name)
                    .padding(.horizontal)
            }
        }
        .alert(isPresented: $addAlbumController.alert.show) {
            Alert(
                title: Text(addAlbumController.alert.title),
                message: Text(addAlbumController.alert.message),
                dismissButton: .default(Text("Продолжить"), action: {
                    if addAlbumController.status == .success {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            )
        }
    }
}
