//
//  SavedPostsViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 30.07.2022.
//

import SwiftUI

class SavedPostsViewModel: ObservableObject {
    
    @Published var savedTextPosts: [PostModel] = []
    @Published var savedTextPostsLoad: Bool = false
    @Published var pageSavedTextPosts = 0
        
    @Published var savedMediaPosts: [[[PostModel]]] = []
    @Published var savedMediaPostsLoad: Bool = false
    @Published var pageSavedMediaPosts = 0
    
    let pageSize = 100
    let pageMediaSize = 100
    
    func getSavedTextPosts () {
        guard let url = URL(string: "\(API_URL)\(API_SAVED_TEXT_POSTS)?page=\(pageSavedTextPosts)&pageSize=\(pageSize)") else { return }
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else { return }
            guard let data = data else {return}
            
            if response.statusCode == 200 {
                guard let responseJson = try? JSONDecoder().decode(PostResponse.self, from: data) else {return}
                
                DispatchQueue.main.async {
                    self.savedTextPosts = responseJson.data
                    self.savedTextPostsLoad = true
                }
            }
        }.resume()
    }
    
    func getSavedMediaPosts (albumId: String) {
        guard let url = URL(string: "\(API_URL)\(API_SAVE_MEDIA_POSTS_ALBUM)\(albumId)?page=\(pageSavedMediaPosts)&pageSize=\(pageMediaSize)") else { return }
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else { return }
            guard let data = data else {return}
            
            if response.statusCode == 200 {
                guard let responseJson = try? JSONDecoder().decode(PostResponse.self, from: data) else {return}
                
                DispatchQueue.main.async {
                    self.savedMediaPosts = self.createCompositionLayer(posts: responseJson.data)
                    self.savedMediaPostsLoad = true
                }
            }
        }.resume()
    }
    
    func createCompositionLayer (posts: [PostModel]) -> [[[PostModel]]] {
        var postComposition: [[[PostModel]]] = []
        var composition: [[PostModel]] = []
        var stack: [PostModel] = []
        
        for (index, post) in posts.enumerated() {
            stack.append(post)

            if stack.count == 2 || (stack.count == 1 &&  index == posts.count - 1) {
                composition.append(stack)
                stack.removeAll()
            }
            
            if composition.count == 3 || (composition.count == 2 && index == posts.count - 1) || (composition.count == 1 && index == posts.count - 1) {

                postComposition.append(composition)
                composition.removeAll()
            }
        }
        
        return postComposition
    }
}
