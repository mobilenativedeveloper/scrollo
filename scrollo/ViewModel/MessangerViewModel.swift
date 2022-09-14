//
//  MessageViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 25.06.2022.
//

import SwiftUI

class MessangerViewModel : ObservableObject {
    
    @Published var chats: [ChatListModel.ChatModel] = []
    @Published var loadChats : Bool = false
    var pageChat = 0
    var pageSizeChat = 100
    
    @Published var favoriteChats: [ChatListModel.ChatModel] = []
    
    //----
    
    @Published var followers: [FollowersResponse.FollowerModel] = []
    @Published var load : Bool = false
    
    @Published var page = 0
    let pageSize = 5
    
    func getChats (completion: @escaping()->Void) {
        guard let url = URL(string: "\(API_URL)\(API_CHAT)?page=\(pageChat)&pageSize=\(pageSizeChat)") else {return}
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
           
            if response.statusCode == 200 {
                guard let json = try? JSONDecoder().decode(ChatListModel.self, from: data) else {return}
                DispatchQueue.main.async {
                    self.chats = json.data
                    self.loadChats = true
                    completion()
                }
            }
        }
        .resume()
    }
    
    func addFavoriteChat(chat: ChatListModel.ChatModel){
        
    }
    
    func deleteFavoriteChat(chatId: String) {
        
    }
    
    
    //--
    
    
    func getFollowers () {
        guard let url = URL(string: "\(API_URL)\(API_GET_USER_FOLLOWERS)?page=\(page)&pageSize=\(pageSize)") else {return}
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            
//            guard let debugJson = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            
            if response.statusCode == 200 {
                guard let json = try? JSONDecoder().decode(FollowersResponse.self, from: data) else {return}
                DispatchQueue.main.async {
                    self.followers = json.data
                    self.load = true
                }
            }
        }
        .resume()

    }
    
    func createChat (userId: String, completion: @escaping(Bool?)->Void) {
        guard let url = URL(string: "\(API_URL)\(API_CHAT)") else {return}
        guard let request = Request(url: url, httpMethod: "POST", body: ["userId": userId]) else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            print(response)
            if response.statusCode == 201 {
                guard let chat = try? JSONDecoder().decode(ChatListModel.ChatModel.self, from: data) else {return}
                DispatchQueue.main.async {
                    self.chats.append(chat)
                    completion(true)
                }
            }
        }
        .resume()
    }
    
    func removeChat(chatId: String){
        guard let url = URL(string: "\(API_URL)\(API_CHAT)\(chatId)") else {return}
        guard let request = Request(url: url, httpMethod: "DELETE", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            guard let response = response as? HTTPURLResponse else {return}
            debugPrint(response)
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                   debugPrint("chat deleted")
                }
            }
        }
        .resume()
    }
}
