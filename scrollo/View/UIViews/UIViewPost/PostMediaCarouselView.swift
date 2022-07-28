//
//  PostMediaCarouselView.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct PostMediaCarouselView: View {
    @State var selection : Int = 0
    
    var images: [PostModel.PostFiles]
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
            VStack {
                TabView(selection: self.$selection) {
                    ForEach(0..<images.count, id: \.self){index in
                        if images[index].type == "IMAGE" {
                            if let path = self.images[index].filePath {
                                WebImage(url: URL(string: "\(API_URL)/uploads/\(path)")!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: UIScreen.main.bounds.width - 48)
                                    .clipped()
                                    .tag(index)
                            }
                        } else if images[index].type == "VIDEO" {
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
            ForEach(0..<images.count, id: \.self) {index in
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.8))
                    .frame(width: self.selection == index ? 28 : 7, height: 4)
                    .padding(.trailing, index != images.count - 1 ? 4 : 0)
                    .animation(.default)
            }
        }
        .offset(x: -10, y: 10)
    }
}

//struct PostMediaCarouselView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostMediaCarouselView()
//    }
//}


struct SlideVideo: View {
    @StateObject var videoThumbnailViewModel: VideoThumbnailViewModel = VideoThumbnailViewModel()
    @State var playVideo: Bool = false
    var path: String
    let player = AVPlayer(url:  URL(string: "https://images.all-free-download.com/footage_preview/mp4/jasmine_flower_6891520.mp4")!)
    
    var body: some View {
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
