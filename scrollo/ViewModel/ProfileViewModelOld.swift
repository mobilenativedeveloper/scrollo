////
////  ProfileViewModel.swift
////  scrollo
////
////  Created by Artem Strelnik on 07.07.2022.
////
//
//import SwiftUI
//
//class ProfileViewModel: ObservableObject {
//    
//    @Published var user: UserModel.User? = nil
//    
//    @Published var textPost: [PostModel] = []
//    @Published var mediaPost: [[PostModel]] = []
//    
//    @Published var loadTextPost: Bool = false
//    @Published var loadMdeiaPost: Bool = false
//
//    func getProfile (userId: String) -> Void {
//        
//        let url = URL(string: "\(API_URL)\(API_GET_USER)\(userId)")!
//        
//        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
//        
//        URLSession.shared.dataTask(with: request) {data, response, _ in
//            
//            
//            guard let response = response as? HTTPURLResponse else {return}
//            guard let data = data else {return}
//            
//            if response.statusCode == 200 {
//                guard let json = try? JSONDecoder().decode(UserModel.User.self, from: data) else {return}
//                DispatchQueue.main.async {
//                    self.user = json
//                }
//            }
//        }.resume()
//    }
//    
//    func getUserTextPosts (userId: String) -> Void {
//        
//        
//        guard let url = URL(string: "\(API_URL)\(API_USER_GET_POST)\(userId)?page=0&pageSize=5&type=TEXT") else {return}
//        
//        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
//        
//        URLSession.shared.dataTask(with: request) { data, response, _ in
//            
//            guard let response = response as? HTTPURLResponse else {return}
//            guard let data = data else {return}
//            
//            if response.statusCode == 200 {
//                
//                guard let posts = try? JSONDecoder().decode(PostResponse.self, from: data) else {return}
//                
//                DispatchQueue.main.async {
//                    if posts.data.count > 0{
//                        self.textPost = posts.data
//                    }
//                    
//                    self.loadTextPost = true
//                }
//            }
//            
//        }.resume()
//    }
//    
//    func getUserMediaPosts (userId: String) -> Void {
//        
//        guard let url = URL(string: "\(API_URL)\(API_USER_GET_POST)\(userId)?page=0&pageSize=100&type=STANDART") else {return}
//        
//        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
//        
//        URLSession.shared.dataTask(with: request) { data, response, _ in
//            
//            guard let response = response as? HTTPURLResponse else {return}
//            guard let data = data else {return}
//            
//            if response.statusCode == 200 {
//                
//                guard let posts = try? JSONDecoder().decode(PostResponse.self, from: data) else {return}
//                
//                DispatchQueue.main.async {
//                    if posts.data.count > 0 {
//                        self.mediaPost = self.createCompositionLayer(posts: posts.data)
//                    } else {
//                        self.mediaPost = []
//                    }
//                    
//                    
//                    self.loadMdeiaPost = true
//                }
//            }
//            
//        }.resume()
//    }
//    
//    func createCompositionLayer(posts: [PostModel]) -> [[PostModel]] {
//        var compositionArray: [[PostModel]] = []
//        
//        var currentArrayPosts: [PostModel] = []
//        
//        posts.forEach { (post) in
//            currentArrayPosts.append(post)
//            
//            if currentArrayPosts.count == 6 {
//                compositionArray.append(currentArrayPosts)
//                currentArrayPosts.removeAll()
//            }
//        }
//        
//        return compositionArray
////        var postComposition: [[[PostModel]]] = []
////
////        var composition: [[PostModel]] = []
////
////        var stack: [PostModel] = []
////
////        for (index, post) in posts.enumerated() {
////
////            stack.append(post)
////
////            if stack.count == 2 || (stack.count == 1 &&  index == posts.count - 1) {
////                composition.append(stack)
////                stack.removeAll()
////            }
////
////            if composition.count == 3 || (composition.count == 2 && index == posts.count - 1) || (composition.count == 1 && index == posts.count - 1) {
////
////                postComposition.append(composition)
////                composition.removeAll()
////            }
////        }
////
////
////        return postComposition
//    }
//    
//    func checkFollowOnUser(userId: String, completion: @escaping (Bool?) -> Void) {
//        let url = URL(string: "\(API_URL)\(API_CHECK_FOLLOW_ON_USER)\(userId)")!
//        
//        if let request = Request(url: url, httpMethod: "GET", body: nil) {
//            URLSession.shared.dataTask(with: request){data, response, error in
//                if let _ = error {
//                    return
//                }
//
//                guard let response = response as? HTTPURLResponse else {return}
//
//                if response.statusCode == 200 {
//                    if let json = try? JSONDecoder().decode(ResponseResult.self, from: data!) {
//                        DispatchQueue.main.async {
//                            if json.result == true {
//                                completion(true)
//                            } else {
//                                completion(false)
//                            }
//                        }
//                    }
//                }
//            }.resume()
//        }
//    }
//    
//    func followOnUser(userId: String, completion: @escaping () -> Void) -> Void {
//        let url = URL(string: "\(API_URL)\(API_FOLLOW_ON_USER)")!
//        
//        let body: [String: String] = [
//            "userId": userId
//        ]
//        
//        if let request = Request(url: url, httpMethod: "POST", body: body) {
//            URLSession.shared.dataTask(with: request){data, response, error in
//                if let _ = error {
//                    return
//                }
//
//                guard let response = response as? HTTPURLResponse else {return}
//
//                if response.statusCode == 200 {
//                    completion()
//                    print(response)
//                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
//                        print(json)
//                    }
//                } else {
//                    print(response)
//                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
//                        print(json)
//                    }
//                    return
//                }
//
//            }.resume()
//        }
//    }
//    
//    func unFollowOnUser(userId: String, completion: @escaping () -> Void) -> Void {
//        let url = URL(string: "\(API_URL)\(API_FOLLOW_ON_USER)\(userId)")!
//        
//        
//        if let request = Request(url: url, httpMethod: "DELETE", body: nil) {
//            URLSession.shared.dataTask(with: request){data, response, error in
//                if let _ = error {
//                    return
//                }
//
//                guard let response = response as? HTTPURLResponse else {return}
//
//                if response.statusCode == 200 {
//                    completion()
//                    print(response)
//                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
//                        print(json)
//                    }
//                }
//            }.resume()
//        }
//    }
//}
