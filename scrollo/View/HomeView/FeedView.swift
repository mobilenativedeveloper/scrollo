//
//  FeedView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject private var storyViewModel: StoryViewModel = StoryViewModel()
    @ObservedObject private var feedPostViewModel: FeedPostViewModel = FeedPostViewModel()
    @State private var isShowing : Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image("logo_large")
                    .resizable()
                    .frame(width: 95, height: 21)
                Spacer()
                NavigationLink(destination: MessageListView().ignoreDefaultHeaderBar) {
                    Image("messanger")
                        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 4)
                }
            }
            .padding(.horizontal)
            .background(Color(hex: "#F9F9F9"))
            List {
                StoriesList()
                    .environmentObject(self.storyViewModel)
                    .ignoreListAppearance()
                
                ForEach(0..<self.feedPostViewModel.posts.count, id:\.self) {index in
                    
                    if let _ = self.feedPostViewModel.posts[index].type == "TEXT" {
                        UIPostTextView(post: self.feedPostViewModel.posts[index])
                            .padding(.bottom, index == self.feedPostViewModel.posts.count - 1 ? 80 : 0)
                            .ignoreListAppearance()
                    }
                    
                    if let _ = self.feedPostViewModel.posts[index].type == "STANDART" {
                        UIPostStandartView(post: self.feedPostViewModel.posts[index])
                            .padding(.bottom, index == self.feedPostViewModel.posts.count - 1 ? 80 : 0)
                            .ignoreListAppearance()
                    }
                    
                    if index == self.feedPostViewModel.posts.count - 1 {
                        Color(hex: "#F9F9F9")
                            .frame(height: 0)
                            .ignoreListAppearance()
                            .onAppear {
                                self.feedPostViewModel.loadMoreContentIfNeeded(currentItem: self.feedPostViewModel.posts[index])
                            }
                    }
                }
                if self.feedPostViewModel.isLoadingPage {
                    ProgressView()
                        .padding(.bottom, 100)
                        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
                        .ignoreListAppearance()
                }
                       
            }
//            .pullToRefresh(isShowing: self.$isShowing) {
//                //MARK: This is update feed
//            }
            .listStyle(.plain)
        }
        .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
        .fullScreenCover(isPresented: self.$storyViewModel.showStory) {
            StoryView()
                .environmentObject(storyViewModel)
        }
    }
    
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}

struct StoriesList : View {
    @EnvironmentObject var storyData: StoryViewModel
    
    
    var body : some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 0) {
                StoriesUserListItem()
                    .padding(.leading, 10)
                ForEach(0..<storyData.stories.count){index in
                    StoriesListItem(story: storyData.stories[index])
                        .padding(.leading, 10)
                }
            }
        }
    }
    
    @ViewBuilder
    func StoriesUserListItem () -> some View {
        VStack {
            Image("Plus")
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(width: 62, height: 62)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 1,dash: [6])
                        )
                        .frame(width: 53, height: 53)
                        .foregroundColor(Color(hex: "#828282"))
                )
                .background(
                    Color.white
                        .frame(width: 65, height: 65)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                )
                .background(
                    Color(hex: "#828282")
                        .frame(width: 68, height: 68)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                )
            Text("Вы")
                .font(Font.custom(GothamMedium, size: 12))
                .foregroundColor(Color(hex: "4F4F4F"))
                .frame(width: 70)
                .lineLimit(1)
                .fixedSize()
        }
        .frame(width: 70, height: 96)
    }
    
    @ViewBuilder
    func StoriesListItem (story: StoryModel) -> some View {
        VStack {
            Image(story.profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 62, height: 62)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .background(
                    Color.white
                        .frame(width: 65, height: 65)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                )
                .background(self.isSeen(seen: story.isSeen))
            Text(story.profileName)
                .font(Font.custom(GothamMedium, size: 12))
                .foregroundColor(Color(hex: "4F4F4F"))
                .frame(width: 70)
                .lineLimit(1)
                .fixedSize()
        }
        .frame(width: 70, height: 96)
        .onTapGesture {
            withAnimation {
                storyData.currentStory = story.id
                storyData.showStory = true
            }
        }
    }
    
    @ViewBuilder
    func isSeen (seen: Bool) -> some View {
        if !seen {
            LinearGradient(gradient: Gradient(colors: [
                Color(hex: "#36DCD8"),
                Color(hex: "#5B86E5")
            ]), startPoint: .leading, endPoint: .trailing)
                .frame(width: 68, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        } else {
            Color(hex: "#E0E0E0")
                .frame(width: 68, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}
