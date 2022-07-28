//
//  FeedStoryView.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI

struct FeedStoryView: View {
    @StateObject private var storyViewModel: StoryViewModel = StoryViewModel()
    
    var body: some View {
        StoriesListView()
            .environmentObject(storyViewModel)
            .fullScreenCover(isPresented: $storyViewModel.showStory) {
                StoryView()
                    .environmentObject(storyViewModel)
            }
    }
}

struct FeedStoryView_Previews: PreviewProvider {
    static var previews: some View {
        FeedStoryView()
    }
}
