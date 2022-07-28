//
//  SavePostViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI

class SavePostViewModel: ObservableObject {
    @Published var isPresentListAbums: Bool = false
    
    func removeSaveMediaPost (postId: String, completed: @escaping() -> Void) {
        guard let url = URL(string: "\(API_URL)\(API_SAVE_POST)/\(postId)") else {return}
        guard let request = Request(url: url, httpMethod: "DELETE", body: nil) else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    completed()
                }
            } else {
                //MARK: toast error
            }
        }.resume()
    }
    
    func saveMediaPost (postId: String, albumId: String, albumName: String, completed: @escaping () -> Void) {
        
        guard let url = URL(string: "\(API_URL)\(API_SAVE_POST)") else { return }
        guard let request = Request(url: url, httpMethod: "POST", body: ["postId": postId, "albumId": albumId]) else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else { return }
            guard let data = data else {return}
            
            if response.statusCode == 200 {
                
                guard let post = try? JSONDecoder().decode(PostModel.self, from: data) else {return}
                if post.files[0].type == "IMAGE" {
                    if let path = post.files[0].filePath {
                        
                        NotificationCenter.default.post(name: NSNotification.Name("save.post"), object: nil, userInfo: [
                            "name": albumName,
                            "image": "\(API_URL)/uploads/\(path)"
                        ])
                    }
                }
                DispatchQueue.main.async {
                    completed()
                }
            } else {
                //MARK: toast error
                print("Post saved error")
            }
        }.resume()
    }
    
    
}
