//
//  PostView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI

struct PostHeader : View {
    
    @EnvironmentObject var bottomSheetViewModel : BottomSheetViewModel
    private let post : PostModel
    var isDetail: Bool
    init (post: PostModel, isDetail: Bool = false) {
        self.post = post
        self.isDetail = isDetail
    }
    
    var body : some View {
        
        HStack(spacing: 0) {
            if let avatar = self.post.creator.avatar {
                WebImage(url: URL(string: "\(API_URL)/uploads/\(avatar)"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .clipped()
                    .cornerRadius(10)
                    .padding(.trailing, 7)
            } else {
                UIDefaultAvatar(width: 35, height: 35, cornerRadius: 10)
                    .padding(.trailing, 7)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(self.post.creator.login)
                    .font(.system(size: 14))
                    .fontWeight(Font.Weight.bold)
                    .foregroundColor(Color(hex: "#333333"))
                    .offset(y: -5)
                if let place = self.post.place {
                    Text("\(place.name)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#909090"))
                } else {
                    Text("Moscow")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#909090"))
                }
            }
            
            Spacer()
            
            Button(action: {
                if isDetail {
                    bottomSheetViewModel.postDetailBottomSheet.toggle()
                } else {
                    bottomSheetViewModel.postBottomSheet.toggle()
                }
                
            }) {
                VStack {
                    Image("menu")
                }
                .frame(width: 50, height: 50)
            }
            .frame(width: 50, height: 50)
            .cornerRadius(50)
            .offset(x: 14)
        }
        
    }
}

struct PostAction: View {
    var activeImage: String
    var inactiveImage: String
    var isActive: Bool
    var count: Int?
    var onPress: () -> Void
    
    var body: some View {
        Button(action: {
            onPress()
        }) {
            HStack(spacing: 0) {
                Image(isActive ? activeImage : inactiveImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 21, height: 21)
                    .padding(.trailing, 6)
                if let count = count {
                    Text("\(count)")
                        .font(Font.custom(GothamBold, size: 12))
                        .foregroundColor(Color.black)
                }
            }
        }
        .frame(height: 20)
        .padding(.horizontal, 17)
        .padding(.vertical, 6)
        .background(isActive ? Color(hex: "#F0F0F0") : Color.clear)
        .cornerRadius(30)
    }
}

struct PostFooter : View {
    @EnvironmentObject var bottomSheetViewModel: BottomSheetViewModel
    @State var isShowingSheet: Bool = false
    @State var presentCommentsView: Bool = false
    @Binding var post : PostModel
    var isDetail: Bool
    init (post: Binding<PostModel>, isDetail: Bool = false) {
        self._post = post
        self.isDetail = isDetail
    }
    
    var body : some View {
        
        HStack(spacing: 5) {

            PostAction(activeImage: "heart_active", inactiveImage: "heart_inactive", isActive: post.liked, count: post.likesCount, onPress: {
                likePost()
            })
            PostAction(activeImage: "dislike_active", inactiveImage: "dislike_inactive", isActive: post.disliked, count: post.dislikeCount, onPress: {
                dislikePost()
            })
            Button(action: {
                presentCommentsView.toggle()
            }) {
                HStack(spacing: 0) {
                    Image("comments")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 21, height: 21)
                        .padding(.trailing, 6)
                    Text("\(self.post.commentsCount)")
                        .font(Font.custom(GothamBold, size: 12))
                        .foregroundColor(Color.black)
                }
                .frame(width: 61, height: 20)
            }

            Button(action: {
                if isDetail {
                    bottomSheetViewModel.isShareDetailBottomSheet.toggle()
                } else {
                    bottomSheetViewModel.isShareBottomSheet.toggle()
                }
            }) {
                Image("share")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 21, height: 21)
            }
            .frame(width: 61, height: 20)
            Spacer(minLength: 0)

            Saved()
        }
        .background(NavigationLink(destination: CommentsView(post: post).ignoreDefaultHeaderBar, isActive: $presentCommentsView) { EmptyView() }.hidden())
    }
    
    func likePost() {
        if !self.post.disliked {
            
            if !self.post.liked {
                guard let url = URL(string: "\(API_URL)\(API_URL_LIKE)") else {return}
                guard let request = Request(url: url, httpMethod: "POST", body: ["postId": self.post.id]) else {return}
                
                URLSession.shared.dataTask(with: request) {data, response, _ in
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    guard let data = data else {return}
                    
                    if response.statusCode == 200 {
                        DispatchQueue.main.async {
//                            guard let newPost = try? JSONDecoder().decode(PostModel.self, from: data) else { return }
                            
                            post.liked = true
                            post.likesCount = post.likesCount + 1
                        }
                    }
                }.resume()
            } else {
                guard let url = URL(string: "\(API_URL)\(API_URL_LIKE)\(self.post.id)") else {return}
                guard let request = Request(url: url, httpMethod: "DELETE", body: nil) else {return}
                
                URLSession.shared.dataTask(with: request) {data, response, _ in
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    guard let data = data else {return}
                    
                    if response.statusCode == 200 {
                        
//                        guard let newPost = try? JSONDecoder().decode(PostModel.self, from: data) else {return}
                        DispatchQueue.main.async {
                            post.liked = false
                            post.likesCount = post.likesCount - 1
                        }
                    }
                }.resume()
            }
        }
    }
    
    func dislikePost() {
        if !self.post.liked {
            if !self.post.disliked {
                guard let url = URL(string: "\(API_URL)\(API_URL_DISLIKE)") else { return }
                guard let request = Request(url: url, httpMethod: "POST", body: ["postId": self.post.id]) else {return}
                
                URLSession.shared.dataTask(with: request) {data, response, _ in
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    guard let data = data else {return}
                    
                    if response.statusCode == 200 {
                        
                        DispatchQueue.main.async {
//                            guard let newPost = try? JSONDecoder().decode(PostModel.self, from: data) else {return}
                            
                            post.disliked = true
                            post.dislikeCount = post.dislikeCount + 1
                        }
                    }
                }.resume()

            } else {
                guard let url = URL(string: "\(API_URL)\(API_URL_DISLIKE)\(self.post.id)") else {return}
                guard let request = Request(url: url, httpMethod: "DELETE", body: nil) else {return}
                
                URLSession.shared.dataTask(with: request) {data, response, _ in
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    guard let data = data else {return}
                    if response.statusCode == 200 {
                        
//                        guard let newPost = try? JSONDecoder().decode(PostModel.self, from: data) else {return}
                        DispatchQueue.main.async {
                            
                            post.disliked = false
                            post.dislikeCount = post.dislikeCount - 1
                        }
                    }
                }.resume()
            }
        }
    }
    
    @ViewBuilder func Saved() -> some View {
        if let userId = UserDefaults.standard.string(forKey: "userId") {
            if userId == self.post.creator.id {
                Color.clear.frame(height: 0)
            } else {
                Button(action: {

                }) {
                    if self.post.inSaved {
                        Image("bookmark_active")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 21, height: 21)
                    } else {
                        Image("bookmark_inactive")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 21, height: 21)
                    }

                }
            }
        } else {
            Color.clear.frame(height: 0)
        }
    }
}

struct TruncateTextView : View {
    @State private var fullPost: Bool = false
    private let text: String
    private let limitedTextLength: Int = 140
    
    init (text: String) {
        self.text = text
    }
    
    var body : some View{
        if self.text.count > self.limitedTextLength {
            let index = self.text.index(self.text.startIndex, offsetBy: self.limitedTextLength)
            VStack(alignment: .leading) {
                if self.fullPost {
                    textWithHashtags(self.text, color: Color(hex: "#5B86E5"))
                        .font(Font.custom(GothamBook, size: 14))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                } else {
                    Group {
                        textWithHashtags(String(self.text.prefix(upTo: index)), color: Color(hex: "#5B86E5")) + Text("...") + Text(" ") + Text("Развернуть").foregroundColor(.blue)
                    }
                    .font(Font.custom(GothamBook, size: 14))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                }
            }
            .onTapGesture(perform: {
                withAnimation(.default) {
                    self.fullPost = true
                }
            })
        } else {
            textWithHashtags(self.text, color: Color(hex: "#5B86E5"))
                .font(Font.custom(GothamBook, size: 14))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
        }
    }
}

struct PostMediaCarousel : View {
    @State var selection : Int = 0
    private let images: [PostModel.PostFiles]
    
    init (images: [PostModel.PostFiles]) {
        self.images = images
    }
    
    var body : some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
            VStack {
                TabView(selection: self.$selection) {
                    ForEach(0..<self.images.count, id: \.self){index in
                        if self.images[index].type == "IMAGE" {
                            if let path = self.images[index].filePath {
                                WebImage(url: URL(string: "\(API_URL)/uploads/\(path)")!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: UIScreen.main.bounds.width - 48)
                                    .clipped()
                                    .tag(index)
                            }
                        } else if self.images[index].type == "VIDEO" {
                            if let path = images[index].filePath {
                                SlideVideo(path: path)
                                    .tag(index)
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(height: UIScreen.main.bounds.width - 48)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 9, x: 0, y: 0)
            Indicator()
        }
    }
    @ViewBuilder
    func Indicator() -> some View {
        HStack {
            ForEach(0..<self.images.count, id: \.self) {index in
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.8))
                    .frame(width: self.selection == index ? 28 : 7, height: 4)
                    .padding(.trailing, index != self.images.count - 1 ? 4 : 0)
                    .animation(.default)
            }
        }
        .offset(x: -10, y: 10)
    }
}

struct SlideVideo : View {
    @StateObject var videoThumbnailViewModel: VideoThumbnailViewModel = VideoThumbnailViewModel()
    @State var playVideo: Bool = false
    var path: String
    let player = AVPlayer(url:  URL(string: "https://images.all-free-download.com/footage_preview/mp4/jasmine_flower_6891520.mp4")!)
    
    var body : some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            if self.playVideo == false {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                    Image(uiImage: videoThumbnailViewModel.thumbnailVideo)
                        .resizable()
                        .scaledToFill()
                        .frame(height: UIScreen.main.bounds.width - 48)
                        .clipped()
                        .background(Color(hex: "#f2f2f2"))
                        .overlay(
                            ProgressView(),
                            alignment: Alignment(horizontal: .center, vertical: .center)
                        )
                    if !videoThumbnailViewModel.load {
                        ProgressView()
                    } else {
                        Image("play_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 73, height: 73)
                    }
                }
                .frame(height: UIScreen.main.bounds.width - 48)
                .background(Color(hex: "#383838"))
                .onTapGesture(perform: {
                    if videoThumbnailViewModel.load {
                        if self.playVideo == true {
                            self.playVideo = false
                        } else {
                            self.playVideo = true
                        }
                    }
                })
            } else {
                UIAVPlayerControllerRepresented(player: AVPlayer(url: URL(string: "\(API_URL)/uploads/\(path)")!))
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.width - 48)
                    .onAppear(perform: {
                        print("UIAVPlayerControllerRepresented play")
                        player.play()
                    })
            }
        }
        .frame(height: UIScreen.main.bounds.width - 48)
        .onAppear{
            if !videoThumbnailViewModel.error {
                videoThumbnailViewModel.createThumbnailFromVideo(url: URL(string: "\(API_URL)/uploads/\(path)")!)
            }
        }
        .onTapGesture(perform: {
            if videoThumbnailViewModel.load {
                if self.playVideo == true {
                    self.playVideo = false
                } else {
                    self.playVideo = true
                }
            }
        })
    }
}

struct UIPostTextView: View {
    @EnvironmentObject var bottomSheetViewModel: BottomSheetViewModel
    @Binding var post: PostModel
    @State var isDetail: Bool = false
    
    public init (post: Binding<PostModel>) {
        self._post = post
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            
            
            PostHeader(post: self.post)
                .padding(.bottom, 13)
            
            TruncateTextView(text: self.post.content)
            
            PostFooter(post: self.$post)
                .padding(.top, 17)
                .environmentObject(bottomSheetViewModel)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 18)
        .padding(.horizontal, 14)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 9, x: 0, y: 0)
        .padding(.vertical, 13.5)
        .padding(.horizontal)
        .background(NavigationLink(destination: PostDetailView(post: $post)
                                    .ignoreDefaultHeaderBar
                                    .environmentObject(bottomSheetViewModel), isActive: $isDetail) { EmptyView() }.hidden())
        .onTapGesture {
            isDetail.toggle()
        }
    }
    
    
    private func share () -> Void {}
}

struct UIPostStandartView : View {
    @EnvironmentObject var bottomSheetViewModel: BottomSheetViewModel
    @Binding var post: PostModel
    @State var isDetail: Bool = false
    
    public init(post: Binding<PostModel>) {
        self._post = post
    }
    
    var body : some View {
        
        VStack(alignment: .leading, spacing: 0){
            
            PostHeader(post: self.post)
                .padding(.bottom, 13)
                .environmentObject(bottomSheetViewModel)
            PostMediaCarousel(images: self.post.files)
                .padding(.bottom, 16)
            TruncateTextView(text: self.post.content)
            
            PostFooter(post: self.$post)
                .padding(.top, 17)
                .environmentObject(bottomSheetViewModel)
            HStack(spacing: 0) {
                ZStack{
                    Image("story1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 18, height: 18)
                        .background(Color(hex: "#F2F2F2"))
                        .clipShape(Circle())
                        .background(
                            Circle()
                                .fill(Color(hex: "#F2F2F2"))
                                .frame(width: 20, height: 20)
                        )
                    Image("story4")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 18, height: 18)
                        .background(Color(hex: "#F2F2F2"))
                        .clipShape(Circle())
                        .background(
                            Circle()
                                .fill(Color(hex: "#F2F2F2"))
                                .frame(width: 20, height: 20)
                        )
                        .offset(x: 10)
                    Image("story3")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 18, height: 18)
                        .background(Color(hex: "#F2F2F2"))
                        .clipShape(Circle())
                        .background(
                            Circle()
                                .fill(Color(hex: "#F2F2F2"))
                                .frame(width: 20, height: 20)
                        )
                        .offset(x: 20)
                }
                .padding(.trailing, 35)
                Text("Привет друзья, как вы? Хочу поделиться новостями...")
                    .font(Font.custom(GothamBook, size: 11))
                    .padding(.trailing, 3)
                Spacer(minLength: 0)
                Button(action: {}){
                    Text("Далее")
                        .font(Font.custom(GothamBook, size: 10))
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                }
                .background(Color(hex: "#F0F0F0"))
                .cornerRadius(50)
            }
            .padding(.top, 20)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 18)
        .padding(.horizontal, 14)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 9, x: 0, y: 0)
        .padding(.vertical, 13.5)
        .padding(.horizontal)
        .background(
            NavigationLink(destination: PostDetailView(post: $post)
                            .ignoreDefaultHeaderBar
                            .environmentObject(bottomSheetViewModel), isActive: $isDetail) { EmptyView() }.hidden()
        )
        .onTapGesture {
            isDetail.toggle()
        }
    }
}
