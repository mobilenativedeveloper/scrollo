//
//  PostView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI

private struct PostHeader : View {
    private let post : PostModel
    
    init (post: PostModel) {
        self.post = post
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
                Color.gray
                    .frame(width: 35, height: 35)
                    .cornerRadius(10)
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

private struct PostAction: View {
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

private struct PostFooter : View {
    
    private let post : PostModel
    
    init (post: PostModel) {
        self.post = post
    }
    
    var body : some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                PostAction(activeImage: "heart_active", inactiveImage: "heart_inactive", isActive: self.post.liked, count: self.post.likesCount, onPress: {
                   
                })
                PostAction(activeImage: "dislike_active", inactiveImage: "dislike_inactive", isActive: self.post.disliked, count: self.post.dislikeCount, onPress: {
                    
                })
                
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
                
                Button(action: {}) {
                    Image("share")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 21, height: 21)
                }
                .frame(width: 61, height: 20)
                
                Spacer(minLength: 0)
                
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
        }
    }
}

private struct TruncateTextView : View {
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

private struct PostMediaCarousel : View {
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
                            Text("VIDEO")
                            if let path = images[index].filePath {
                                Text("VIDEO")
//                                SlideVideo()
//                                    .tag(index)
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

private struct SlideVideo : View {
    @ObservedObject var videoThumbnailViewModel: VideoThumbnailViewModel = VideoThumbnailViewModel()
    @State var playVideo: Bool = false
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
                UIAVPlayerControllerRepresented(player: player)
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.width - 48)
                    .onAppear(perform: {
                        print("UIAVPlayerControllerRepresented play")
                        player.play()
                    })
            }
        }
        .frame(height: UIScreen.main.bounds.width - 48)
        .onAppear(perform: {
            videoThumbnailViewModel.createThumbnailFromVideo(url: URL(string: "https://images.all-free-download.com/footage_preview/mp4/jasmine_flower_6891520.mp4")!)
        })
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
    private let post : PostModel
    
    public init (post: PostModel) {
        self.post = post
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            PostHeader(post: self.post)
                .padding(.bottom, 13)
            
            TruncateTextView(text: self.post.content)
            
            PostFooter(post: self.post)
                .padding(.top, 17)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 14)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 9, x: 0, y: 0)
        .padding(.vertical, 13.5)
        .padding(.horizontal, 10)
    }
    
    
    private func share () -> Void {}
}

struct UIPostStandartView : View {
    private let post: PostModel
    
    public init(post: PostModel) {
        self.post = post
    }
    
    var body : some View {
        
        VStack(alignment: .leading, spacing: 0){
            
            PostHeader(post: self.post)
                .padding(.bottom, 13)
            PostMediaCarousel(images: self.post.files)
                .padding(.bottom, 16)
            TruncateTextView(text: self.post.content)
            
            PostFooter(post: self.post)
                .padding(.top, 17)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 18)
        .padding(.horizontal, 14)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 9, x: 0, y: 0)
        .padding(.vertical, 13.5)
        .padding(.horizontal, 10)
    }
}
