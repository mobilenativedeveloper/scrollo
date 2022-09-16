//
//  MessageViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 25.06.2022.
//

import SwiftUI

class ChatViewModel : ObservableObject {
    
    @Published var chats: [ChatListModel.ChatModel] = []
    @Published var loadChats : Bool = false
    var pageChat = 0
    var pageSizeChat = 100
    
    
    @Published var favoriteChats: [ChatListModel.ChatModel] = []
    
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
    
    //MARK: Success | Error not
    func removeChat(chatId: String){
        guard let url = URL(string: "\(API_URL)\(API_CHAT)\(chatId)") else {return}
        guard let request = Request(url: url, httpMethod: "DELETE", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                
            }
        }
        .resume()
    }
    
    
}
