//
//  MessageViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 15.09.2022.
//

import SwiftUI

class MessageViewModel: ObservableObject{
    
    @Published var message : String = String()
    
    @Published var messages: [MessageModel] = []
    
    func sendMessage(message: MessageModel){
        self.messages.append(message)
    }
}
