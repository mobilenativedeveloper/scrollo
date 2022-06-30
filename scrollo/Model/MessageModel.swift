//
//  MessageModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 25.06.2022.
//

import SwiftUI

struct ChatModel {
    var id: String
    var starter: ChatUserModel
    var receiver: ChatUserModel
}

struct ChatMessageModel {
    var id: String
    var content: String
    var sender: ChatUserModel
    var receiver:ChatUserModel
    var attachments: [AttachmentsModel]
    var createdAt: String
    var updatedAt: String
}

struct AttachmentsModel {
    var id: String
    var path: String
}

struct ChatUserModel {
    var id: String
    var login: String
    var name: String
    var avatar: String
}


struct UserMessageModel {
    var avatar : String
    var login : String
    var online : Bool
    var time : String
    var messages : [String]
    var viewed : Bool
}
