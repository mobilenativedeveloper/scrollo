//
//  AddPostViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 09.07.2022.
//

import SwiftUI

class AddTextPostViewModel: ObservableObject {
    
    @Published var load: Bool = false
    @Published var content: String = ""
    @Published var alert: AlertModel = AlertModel(title: "", message: "", show: false)
    
    func publish(completion: @escaping (PostModel?) -> Void) -> Void {
        if self.content.isEmpty {
            self.alert = AlertModel(title: "Ошибка", message: "Введите текст публикации.", show: true)
            return
        }
        self.load = true
        
        guard let url = URL(string: "\(API_URL)\(API_ADD_POST)") else {return}
        
        guard let request = MultipartRequest(url: url, httpMethod: "POST", parameters: ["content": self.content, "type": "TEXT"]) else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            
            if response.statusCode == 201 {
                guard let post = try? JSONDecoder().decode(PostModel.self, from: data) else {return}
                DispatchQueue.main.async {
                    self.load = false
                    completion(post)
                }
            } else {
                DispatchQueue.main.async {
                    self.alert = AlertModel(title: "Ошибка", message: "Не удалось опубликовать пост, попробуйте еще раз.", show: true)
                }
            }
        }.resume()
    }
}
