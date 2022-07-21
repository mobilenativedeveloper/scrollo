//
//  ConfidentialityModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 08.07.2022.
//

import SwiftUI

struct ConfidentialityModel: Decodable {
    var writeComments: String
    var mark: String
    var writeMessage: String
    
    enum CodingKeys: CodingKey {
        case writeComments, mark, writeMessage
    }
}
