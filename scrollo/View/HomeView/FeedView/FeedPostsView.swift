//
//  FeedPostsView.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI

struct FeedPostsView: View {
    @EnvironmentObject var feedController: FeedPostViewModel
    
    var body: some View {
        if feedController.status == .initial || feedController.status == .loading {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        } else if (feedController.status == .success && feedController.posts.count == 0) {
            EmptyFeedView()
                .padding(.top, 35)
        } else {
            VStack(spacing: 0) {
                ForEach(0..<feedController.posts.count, id:\.self) {index in
                    if feedController.posts[index].type == "STANDART" {
                        UIViewStandartPost(post: $feedController.posts[index])
                            .transition(.opacity)
                    }
                    if feedController.posts[index].type == "TEXT" {
                        UIViewTextPost(post: $feedController.posts[index])
                            .transition(.opacity)
                    }
                    if index % 2 == 0 {
                        ProbablyFamiliarView()
                            .transition(.opacity)
                    }
                    if index == feedController.posts.count - 1 && !feedController.canLoadMorePages {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding(.top)
                        .onAppear {
                            feedController.loadMore()
                        }
                    }
                }
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name(postRemoveFromFeed), object: nil, queue: .main) { (notification) in
                    guard let postId = notification.userInfo?["postId"] as? String else {return}
                    if let index = feedController.posts.firstIndex(where: {$0.id == postId}) {
                        feedController.posts.remove(at: index)
                    }
                }
                NotificationCenter.default.addObserver(forName: NSNotification.Name(addTextPostToFeed), object: nil, queue: .main) { (notification) in
                    guard let post = notification.userInfo?["post"] as? PostModel else {return}
                    var newFeed: [PostModel] = []
                    newFeed.append(post)
                    newFeed += feedController.posts
                    feedController.posts = newFeed
                }
            }
        }
    }
}

struct FeedPostsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedPostsView()
    }
}
