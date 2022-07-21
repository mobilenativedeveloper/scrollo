//
//  NotifyViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 10.07.2022.
//

import UIKit

class NotifyViewModel: ObservableObject {
    
    //MARK: Post feed notify
    @Published var alertPost: AlertModel = AlertModel(title: "", message: "", show: false)
    @Published var updateFeedPost: PostModel? = nil {
        didSet {
            guard let _ = self.updateFeedPost else {return}
            self.alertPost = AlertModel(title: "Успех", message: "Ваш пост опубликован.", show: true)
        }
    }
}
