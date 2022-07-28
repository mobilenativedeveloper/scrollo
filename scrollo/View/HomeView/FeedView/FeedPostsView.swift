//
//  FeedPostsView.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI

struct FeedPostsView: View {
    @StateObject var feedController: FeedPostViewModel = FeedPostViewModel()
    
    var body: some View {
        if feedController.status == .initial || feedController.status == .loading {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        } else {
            ForEach(0..<feedController.posts.count, id:\.self) {index in
                if feedController.posts[index].type == "STANDART" {
                    UIViewStandartPost(post: $feedController.posts[index])
                }
                if feedController.posts[index].type == "TEXT" {
                    UIViewTextPost(post: $feedController.posts[index])
                }
                if index % 2 == 0 {
                    ProbablyFamiliarView()
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
    }
}

struct FeedPostsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedPostsView()
    }
}
