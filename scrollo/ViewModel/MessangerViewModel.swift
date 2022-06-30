//
//  MessageViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 25.06.2022.
//

import SwiftUI

class MessangerViewModel : ObservableObject {
    
    //MARK: Chat list
    @Published var chats : [ChatModel] = [
        ChatModel(id: "b2b7fc9d-d1b5-4787-9190-65f45bf41867", starter: ChatUserModel(id: "b2b7fc9d-d1b5-4787-9190-65f45bf41867", login: "", name: "", avatar: ""), receiver: ChatUserModel(id: "b2b7fc9d-d1b5-4787-9190-65f45bf41867", login: "", name: "", avatar: ""))
    ]
    //MARK: Messages list
    @Published var messages : [ChatMessageModel] = [
        ChatMessageModel(id: "", content: "", sender: ChatUserModel(id: "", login: "", name: "", avatar: ""), receiver: ChatUserModel(id: "", login: "", name: "", avatar: ""), attachments: [], createdAt: "", updatedAt: "")
    ]
    
    private var load : Bool = false
    
    init () {
        self.load = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.load = false
        }
    }
}
