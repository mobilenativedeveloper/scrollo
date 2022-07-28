//
//  FeedView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        VStack(spacing: 0) {
            FeedHeaderView()
            List {
                FeedStoryView()
                    .ignoreListAppearance()
                FeedPostsView()
                    .ignoreListAppearance()
                //MARK: Padding bottom tabbar
                Spacer(minLength: 150)
                    .ignoreListAppearance()
            }
            .listStyle(.plain)
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


