//
//  MessangerModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 13.09.2022.
//

import SwiftUI

struct ChatListModel: Decodable {
    var data: [ChatModel]
    var page: Int
    var totalPages: Int
    var totalElements: Int
    
    enum CodingKeys: CodingKey {
        case data, page, totalPages, totalElements
    }
    
    struct ChatModel: Decodable {
        var id: String
        var starter: ChatUser
        var receiver: ChatUser
        
        enum CodingKeys: CodingKey {
            case id, starter, receiver
        }
        
        
        struct ChatUser: Decodable {
            var id: String
            var login: String
            var name: String?
            var avatar: String?
            
            enum CodingKeys: CodingKey {
                case id, login, name, avatar
            }
        }
    }
}
