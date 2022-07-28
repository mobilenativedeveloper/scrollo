//
//  File.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI

class ToastViewModel: ObservableObject {
    
    @Published var isPresentSavedPost: Bool = false
    @Published var savedPostAlbumName: String = ""
    @Published var savedPostAlbumImage: String = ""
    
}
