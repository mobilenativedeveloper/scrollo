//
//  FeedView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

struct FeedView: View {
    @StateObject var feedController: FeedPostViewModel = FeedPostViewModel()
    var body: some View {
        VStack(spacing: 0) {
            FeedHeaderView()
            VStack(spacing: 0) {
                FeedStoryView()
                    .ignoreListAppearance()
                FeedPostsView()
                    .environmentObject(feedController)
                    .ignoreListAppearance()
                //MARK: Padding bottom tabbar
                Spacer(minLength: 150)
                    .ignoreListAppearance()
            }
            .refreshableCompat(
                showsIndicators: false, onRefresh: { done in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        feedController.page = 0
                        feedController.getPostsFeed {
                            done()
                        }
                    }
                },
                progress: { state in
                    RefreshActivityIndicator(isAnimating: state == .loading) {
                        $0.hidesWhenStopped = false
                    }
                }
            )
            Spacer()
        }
        .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}


