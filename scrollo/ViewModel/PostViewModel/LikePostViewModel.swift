//
//  PostViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI

class LikePostViewModel: ObservableObject {
    
    func addLike (postId: String, completed: @escaping () -> Void) {
        guard let url = URL(string: "\(API_URL)\(API_URL_LIKE)") else {return}
        guard let request = Request(url: url, httpMethod: "POST", body: ["postId": postId]) else {return}
        
        URLSession.shared.dataTask(with: request) {_, response, _ in
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
    
    func removeLike (postId: String, completed: @escaping () -> Void) {
        guard let url = URL(string: "\(API_URL)\(API_URL_LIKE)\(postId)") else {return}
        guard let request = Request(url: url, httpMethod: "DELETE", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) {_, response, _ in
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
}
