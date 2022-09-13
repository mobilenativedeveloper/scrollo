//
//  PostViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

enum FeedStatus { case initial, loading, success, error }

class FeedPostViewModel: ObservableObject {
    @Published var status: FeedStatus = .initial
    
    @Published var posts: [PostModel] = []
    
    @Published var canLoadMorePages: Bool = false
    @Published var isLoadMore: Bool? = nil
    
    @Published var page = 0
    let pageSize = 5
    
    init () {
        self.getPostsFeed(completion: {
            
        })
    }
    
    func getPostsFeed(completion: @escaping () -> Void) {
        if self.status == .initial || self.status == .error { self.status = .loading }
        
        guard let url = URL(string: "\(API_URL)\(API_GET_FEED_POST)?page=\(page)&pageSize=\(pageSize)") else {return}
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else { return }
        
        URLSession.shared.dataTask(with: request) {(data, response, _) in
            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                
                guard let data = data else {return}
                guard let json = try? JSONDecoder().decode(PostResponse.self, from: data) else { return }
                
                DispatchQueue.main.async {
                    self.canLoadMorePages = self.page == json.totalPages
                    if self.isLoadMore == true {
                        self.posts += json.data
                    } else {
                        self.posts = json.data
                    }
                        
                    
                    if self.isLoadMore == true { self.isLoadMore = false }
                    if self.status == .initial || self.status == .loading {
                        self.status = .success
                    }
                    completion()
                }
            }
            
        }.resume()
    }
    
    func loadMore () -> Void {
        
        if !self.canLoadMorePages {
            self.isLoadMore = true
            self.page += 1
            print(self.page)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.getPostsFeed(completion: {
                    
                })
            }
        }
    }
}
