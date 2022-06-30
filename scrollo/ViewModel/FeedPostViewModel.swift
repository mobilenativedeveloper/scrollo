//
//  PostViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

class FeedPostViewModel: ObservableObject {
    //36
    @Published var posts : [PostModel] = []
    @Published var isLoadingPage : Bool = false
    private var countPostsOnPage : Int = 5
    private var currentPage = 1
    private var postCountLoad = 5
    private var canLoadMorePages = true
    
    init () {
        self.getFeedPosts()
    }
    
    
    func getFeedPosts() -> Void {
        
        guard !self.isLoadingPage && self.canLoadMorePages else {
          return
        }
        
        self.isLoadingPage = true
        
        let url = URL(string: "\(API_URL)\(API_GET_FEED_POST)?page=\(self.currentPage)&pageSize=\(self.postCountLoad)")!
        
        if let request = Request(url: url, httpMethod: "GET", body: nil) {
            
            URLSession.shared.dataTask(with: request){data, response, error in
                if let _ = error { return }
                
                guard let response = response as? HTTPURLResponse else {return}
                
                if response.statusCode == 200 {
                    if let feed = try? JSONDecoder().decode(FeedResponse.self, from: data!) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.canLoadMorePages = self.currentPage != feed.totalPages
                            self.isLoadingPage = false
                            self.currentPage += 1
                            self.posts += feed.data
                        }
                    }
                }
            }.resume()
        }
    }
    
    func loadMoreContentIfNeeded(currentItem item: PostModel?) {
        guard let item = item else {
            self.getFeedPosts()
            return
        }

        let thresholdIndex = posts.index(posts.endIndex, offsetBy: -5)
        if posts.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            self.getFeedPosts()
        }
    }
}
