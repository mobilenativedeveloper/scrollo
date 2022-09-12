//
//  MessageViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 25.06.2022.
//

import SwiftUI

class MessangerViewModel : ObservableObject {
    
//    //MARK: Chat list
//    @Published var chats : [ChatModel] = [
//        ChatModel(id: "b2b7fc9d-d1b5-4787-9190-65f45bf41867", starter: ChatUserModel(id: "b2b7fc9d-d1b5-4787-9190-65f45bf41867", login: "", name: "", avatar: ""), receiver: ChatUserModel(id: "b2b7fc9d-d1b5-4787-9190-65f45bf41867", login: "", name: "", avatar: ""))
//    ]
//    //MARK: Messages list
//    @Published var messages : [UserMessageModel] = [
//        UserMessageModel(avatar: "testUserPhoto", login: "Login1", online: true, time: "4", messages: [
//            "tesxt"
//        ], viewed: false),
//        UserMessageModel(avatar: "testUserPhoto", login: "Login1", online: true, time: "4", messages: [
//            "tesxt"
//        ], viewed: false),
//        UserMessageModel(avatar: "testUserPhoto", login: "Login1", online: true, time: "4", messages: [
//            "tesxt"
//        ], viewed: false),
//        UserMessageModel(avatar: "testUserPhoto", login: "Login1", online: true, time: "4", messages: [
//            "tesxt"
//        ], viewed: false),
//    ]
    
    private var load : Bool = false
    
    init () {
        self.load = true
        getFollowers()
        
    }
    
    func getFollowers () {
        guard let url = URL(string: "\(API_URL)\(API_GET_USER_FOLLOWERS)") else {return}
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                debugPrint(response)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.load = false
                }
            }
        }
        .resume()

    }
}
