//
//  AlbumModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI

enum AlbumStatus {
    case initial
    case load
    case success
    case error
}

struct AlbumModel:  Identifiable, Decodable {
    var id: String
    var name: String
    var preview: [String]
    
    enum CodingKeys: CodingKey {
        case id, name, preview
    }
}

struct AlbumListResponseModel: Decodable {
    var data: [AlbumModel]
    var page: Int
    var totalPages: Int
}
