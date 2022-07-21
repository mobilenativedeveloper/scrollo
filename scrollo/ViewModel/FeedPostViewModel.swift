//
//  PostViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

class FeedPostViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    @Published var isLoadingPage = false
    @Published var load : Bool = false
    
    @Published var isLoadMore: Bool = false
    @Published var canLoadMorePages: Bool = false
    @Published var page = 0
    @Published var pageSize = 5
    @Published var refreshable: Bool = false
    
    init () {
        self.getPostsFeed()
    }
    
    func getPostsFeed () {
        if self.refreshable {
            self.page = 0
            self.canLoadMorePages = false
        }
        guard let url = URL(string: "\(API_URL)\(API_GET_FEED_POST)?page=\(page)&pageSize=\(pageSize)") else {return}
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else { return }
        
        URLSession.shared.dataTask(with: request) {(data, response, _) in
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            guard let json = try? JSONDecoder().decode(PostResponse.self, from: data) else { return }
            
            if response.statusCode == 200 {
                
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
