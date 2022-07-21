//
//  FeedView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var notify: NotifyViewModel
    @EnvironmentObject var bottomSheetViewModel: BottomSheetViewModel
    @StateObject private var storyViewModel: StoryViewModel = StoryViewModel()
//    @StateObject private var feedController: feedController = feedController()
    @StateObject var feedController: FeedController = FeedController()
    
    var body: some View {
        VStack(spacing: 0) {
            //MARK: Header bar
            HStack {
                Image("logo_large")
                    .resizable()
                    .frame(width: 95, height: 21)
                Spacer()
                NavigationLink(destination: MessangerView().ignoreDefaultHeaderBar) {
                    Image("messanger")
                        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 4)
                }
            }
            .padding(.horizontal)
            .background(Color(hex: "#F9F9F9"))
            
            
            List {
                //MARK: Stories
                StoriesList()
                    .ignoreListAppearance()
                    .environmentObject(self.storyViewModel)
                //MARK: Feed
                if feedController.load {
                    ForEach(0..<feedController.posts.count, id:\.self) {index in
                        //MARK: STANDART post
                        if feedController.posts[index].type == "STANDART" {
                            UIPostStandartView(post: self.$feedController.posts[index])
                                .ignoreListAppearance()
                                .environmentObject(self.notify)
                                .environmentObject(bottomSheetViewModel)
                        }
                        //MARK: TEXT post
                        if feedController.posts[index].type == "TEXT" {
                            UIPostTextView(post: self.$feedController.posts[index])
                                .ignoreListAppearance()
                                .environmentObject(feedController)
                                .environmentObject(bottomSheetViewModel)
                        }
                        //MARK: ---------
                        if index % 2 == 0 {
                            ProbablyFamiliar().ignoreListAppearance()
                        }
                        
                        if index == feedController.posts.count - 1 {
                            Color.clear.frame(height: 0)
                                .ignoreListAppearance()
                                .onAppear(perform: feedController.loadMore)
                            if feedController.isLoadMore {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .onAppear {
                                            feedController.loadMore()
                                        }
                                    Spacer()
                                }
                                .ignoreListAppearance()
                            }
                            Color.clear.frame(height: 100).ignoreListAppearance()
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }.ignoreListAppearance()
                }
            }
            .listStyle(.plain)
            .refreshable {
                feedController.refreshable = true
                feedController.getPostsFeed()
            }
            Spacer()
        }
        .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
        .onAppear(perform: feedController.getPostsFeed)
        //MARK: Notify update feed on add post
        .onReceive(notify.$updateFeedPost) { (value) in
            guard let newPost = value else {return}
            feedController.posts.append(newPost)
            self.notify.updateFeedPost = nil
        }
        .alert(isPresented: self.$notify.alertPost.show, content: {
            Alert(title: Text(self.notify.alertPost.title), message: Text(self.notify.alertPost.message), dismissButton: .default(Text("Продолжить")))
        })
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
                    .padding(.leading)
                
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

struct ProbablyFamiliar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Возможно вам знакомы")
                .font(.custom(GothamBold, size: 12))
                .foregroundColor(.black)
                .padding(.top, 18)
                .padding(.bottom, 8)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self){index in
                        ProbablyFamiliarItem(photo: "story1", username: "Андрей Булкин", login: "@Andy_bakkery")
                            .padding(.trailing, index == 6 ? 0 : 19)
                    }
                }
                .padding(.vertical)
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    private func ProbablyFamiliarItem(photo: String, username: String, login: String) -> some View {
        VStack(spacing: 0) {
            Image(photo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 94, height: 91)
                .cornerRadius(15)
                .padding(.horizontal, 4)
                .padding(.top, 5)
                .padding(.bottom, 6)
            Text(username)
                .font(.custom(GothamBold, size: 8))
                .foregroundColor(.black)
                .padding(.bottom, 3)
            Text(login)
                .font(.custom(GothamBook, size: 7))
                .foregroundColor(Color(hex: "#919191"))
                .padding(.bottom, 9)
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color(hex: "#040404").opacity(0.1), radius: 4, x: 0, y: 0)
    }
}


class FeedController : ObservableObject {
    
    @Published var alert: AlertModel = AlertModel(title: "", message: "", show: false)
    
    @Published var load : Bool = false
    
    @Published var isLoadMore: Bool = false
    
    @Published var refreshable: Bool = false
    
    @Published var canLoadMorePages: Bool = false
    
    @Published var posts: [PostModel] = []
    
    private var page = 0
    
    private let pageSize = 5
    
    func getPostsFeed () {
        if self.refreshable {
            self.page = 0
            self.canLoadMorePages = false
        }
        
        guard let url = URL(string: "\(API_URL)\(API_GET_FEED_POST)?page=\(page)&pageSize=\(pageSize)") else {return}
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else { return }
        
        URLSession.shared.dataTask(with: request) {(data, response, _) in
            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                
                guard let data = data else {return}
                guard let json = try? JSONDecoder().decode(PostResponse.self, from: data) else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.canLoadMorePages = self.page == json.totalPages
                    if self.refreshable {
                        self.posts = json.data
                        self.refreshable = false
                    } else {
                        self.posts += json.data
                    }
                    if self.isLoadMore { self.isLoadMore = false }
                    if !self.load { self.load = true }
                }
            }
            
        }.resume()
    }
    
    func loadMore () -> Void {
        
        if !self.canLoadMorePages {
            self.isLoadMore = true
            self.page += 1
            print(self.page)
            self.getPostsFeed()
        } else {
            print("POST END")
        }
    }
}
