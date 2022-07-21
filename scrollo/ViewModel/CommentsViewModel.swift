//
//  CommentsViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 05.07.2022.
//

import SwiftUI

class CommentsViewModel: ObservableObject {
    @Published var comments : [PostModel.CommentsModel] = []
    @Published var load : Bool = false
    @Published var content : String = String()
    
    func getPostComments (postId: String) -> Void {
        let url = URL(string: "\(API_URL)\(API_GET_COMMENTS)\(postId)?page=0&pageSize=10")!
        
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else { return }
        
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let _ = error { return }

            guard let response = response as? HTTPURLResponse else {return}

            if response.statusCode == 200 {
                if let json = try? JSONDecoder().decode(CommentsResponse.self, from: data!) {
                    DispatchQueue.main.async {
                        self.comments = json.data
                        self.load = true
                    }
                }
            }
        }.resume()
    }
    
    func addComment (postId: String) -> Void {
        
        let url = URL(string: "\(API_URL)\(API_URL_ADD_COMMENT)")!
        let data: [String: Any] = ["postId": postId, "comment": self.content]
        
        guard let request = Request(url: url, httpMethod: "POST", body: data) else { return }
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let _ = error {
                return
            }

            guard let response = response as? HTTPURLResponse else {return}

            if response.statusCode == 200 {
                if let comment = try? JSONDecoder().decode(PostModel.CommentsModel.self, from: data!) {
                    
                    DispatchQueue.main.async {
                        self.comments.append(comment)
                    }
                }
            }
        }.resume()
    }
    
    func addReply (postCommentId: String) -> Void {
        let url = URL(string: "\(API_URL)\(API_URL_ADD_REPLY_COMMENT)")!
        let data: [String: Any] = ["postCommentId": postCommentId, "content": self.content]
        
        guard let request = Request(url: url, httpMethod: "POST", body: data) else { return }
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let _ = error { return }

            guard let response = response as? HTTPURLResponse else {return}

            if response.statusCode == 200 {
                if let comment = try? JSONDecoder().decode(PostModel.LastSubComments.self, from: data!) {
                    
                    DispatchQueue.main.async {
                        guard let index = self.comments.firstIndex(where: {
                            $0.id == postCommentId
                        }) else { return }
                        
                        self.comments[index].lastSubComments.append(comment)
                    }
                }
            }
        }.resume()
    }
    
    func likeComment (postCommentId: String) -> Void {
        let url = URL(string: "\(API_URL)\(API_LIKE_COMMENT)")!
        let data: [String: Any] = ["postCommentId": postCommentId]
        
        guard let request = Request(url: url, httpMethod: "POST", body: data) else {return}
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let _ = error {return}

            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    guard let index = self.comments.firstIndex(where: {$0.id == postCommentId}) else {return}
                            
                    self.comments[index].liked = true
                    self.comments[index].likesCount = (self.comments[index].likesCount ?? 0) + 1
                }
            }
        }.resume()
    }
    
    func likeRemoveComment (postCommentId: String) -> Void {
        let url = URL(string: "\(API_URL)\(API_LIKE_REMOVE_COMMENT)\(postCommentId)")!
        
        guard let request = Request(url: url, httpMethod: "DELETE", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let _ = error {
                return
            }

            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    guard let index = self.comments.firstIndex(where: {$0.id == postCommentId}) else {return}
                            
                    self.comments[index].liked = false
                    self.comments[index].likesCount = self.comments[index].likesCount! - 1
                }
            }
        }.resume()
    }
    
    func replyLike (postCommentId: String, postCommentReplyId: String) -> Void {
        let url = URL(string: "\(API_URL)\(API_REPLY_LIKE)")!
        let data: [String: Any] = ["postCommentReplyId": postCommentReplyId]
        
        guard let request = Request(url: url, httpMethod: "POST", body: data) else {return}
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let _ = error {return}

            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    guard let commentIndex = self.comments.firstIndex(where: {$0.id == postCommentId}) else {return}
                    guard let replyIndex = self.comments[commentIndex].lastSubComments.firstIndex(where: {$0.id == postCommentReplyId}) else {return}
                            
                    self.comments[commentIndex].lastSubComments[replyIndex].liked = true
                    self.comments[commentIndex].lastSubComments[replyIndex].likesCount = (self.comments[commentIndex].lastSubComments[replyIndex].likesCount ?? 0) + 1
                }
            }
        }.resume()
    }
    
    func replyLikeRemove (postCommentId: String, postCommentReplyId: String) -> Void {
        
        let url = URL(string: "\(API_URL)\(API_REPLY_LIKE)/\(postCommentReplyId)")!
        
        guard let request = Request(url: url, httpMethod: "DELETE", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let _ = error {return}

            guard let response = response as? HTTPURLResponse else {return}
            
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    guard let commentIndex = self.comments.firstIndex(where: {$0.id == postCommentId}) else {return}
                    guard let replyIndex = self.comments[commentIndex].lastSubComments.firstIndex(where: {$0.id == postCommentReplyId}) else {return}
                            
                    self.comments[commentIndex].lastSubComments[replyIndex].liked = false
                    self.comments[commentIndex].lastSubComments[replyIndex].likesCount = self.comments[commentIndex].lastSubComments[replyIndex].likesCount! - 1
                }
            }
        }.resume()
    }
}
