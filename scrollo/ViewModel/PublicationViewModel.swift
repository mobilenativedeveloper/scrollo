//
//  PublicationViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 09.07.2022.
//

import SwiftUI

class PublicationViewModel: ObservableObject {
    
    //MARK: Present publication text post
    @Published var presentPublicationTextPostView: Bool = false
    //MARK: Present publication media post
    @Published var presentPublicationMediaPostView: Bool = false
    //MARK: Present publication story
    @Published var presentPublicationStoryView: Bool = false
}
