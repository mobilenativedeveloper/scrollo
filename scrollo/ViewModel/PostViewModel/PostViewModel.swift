//
//  PostViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

class PostViewModel: ObservableObject {
    
    @Published var textPost: [PostModel] = []
    @Published var mediaPost: [[[PostModel]]] = []
    
    @Published var loadTextPost: Bool = false
    @Published var loadMdeiaPost: Bool = false
    
    func getUserTextPosts (userId: String) -> Void {
        
        
        guard let url = URL(string: "\(API_URL)\(API_USER_GET_POST)\(userId)?page=0&pageSize=5&type=TEXT") else {return}
        
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            
            if response.statusCode == 200 {
                
                guard let posts = try? JSONDecoder().decode(PostResponse.self, from: data) else {return}
                
                DispatchQueue.main.async {
                    if posts.data.count > 0{
                        self.textPost = posts.data
                    }
                    
                    self.loadTextPost = true
                }
            }
            
        }.resume()
    }
    
    func getUserMediaPosts (userId: String) -> Void {
        
        guard let url = URL(string: "\(API_URL)\(API_USER_GET_POST)\(userId)?page=0&pageSize=100&type=STANDART") else {return}
        
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            
            if response.statusCode == 200 {
                
                guard let posts = try? JSONDecoder().decode(PostResponse.self, from: data) else {return}
                
                DispatchQueue.main.async {
                    if posts.data.count > 0 {
                        self.mediaPost = self.createCompositionLayer(posts: posts.data)
                    } else {
                        self.mediaPost = []
                    }
                    
                    
                    self.loadMdeiaPost = true
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
