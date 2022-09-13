//
//  UIPostCompositionView.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct UIPostCompositionView: View {
    @Binding var post: PostModel
    var index: Int
    var columnIndex: Int
    let size = (UIScreen.main.bounds.width / 3) - 16
    
    var body: some View {
        if post.files[0].type == "IMAGE" {
            if let path = post.files[0].filePath {
                NavigationLink(destination:
                                PostDetailView(post: $post).ignoreDefaultHeaderBar
                ) {
                    WebImage(url: URL(string: "\(API_URL)/uploads/\(path)")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: self.getHeight())
                        .clipped()
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(6)
                }
//                .buttonStyle(FlatLinkStyle())
            }
        } else {
            if let path = post.files[0].filePath {
                NavigationLink(destination:
                                PostDetailView(post: $post).ignoreDefaultHeaderBar
                ) {
                    VideoThumbnail(video: URL(string: "\(API_URL)/uploads/\(path)")!, width: size, height: self.getHeight())
                }
//                .buttonStyle(FlatLinkStyle())
            }
        }
    }
    
    func getHeight () -> CGFloat {
        if columnIndex == 0 && index == 0 {
            return 121
        }
        if columnIndex == 0 && index == 1 {
            return 189
        }
        if columnIndex == 1 && index == 0 {
            return 189
        }
        if columnIndex == 1 && index == 1 {
            return 121
        }
        if columnIndex == 2 && index == 0 {
            return 121
        }
        if columnIndex == 2 && index == 1 {
            return 189
        }
        return 0
    }
}


struct VideoThumbnail: View {
    @StateObject var videoThumbnailViewModel: VideoThumbnailViewModel = VideoThumbnailViewModel()
    var video: URL
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Image(uiImage: videoThumbnailViewModel.thumbnailVideo)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()
            .background(Color.gray.opacity(0.5))
            .cornerRadius(6)
            .onAppear{
                if !videoThumbnailViewModel.error {
                    videoThumbnailViewModel.createThumbnailFromVideo(url: video)
                }
            }
    }
}

//struct UIPostCompositionView_Previews: PreviewProvider {
//    static var previews: some View {
//        UIPostCompositionView()
//    }
//}
