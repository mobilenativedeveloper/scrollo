//
//  RemovePostViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 20.08.2022.
//

import SwiftUI

class RemovePostViewModel: ObservableObject {
    
    func removePost(postId: String, completed: @escaping () -> Void) {
        
        guard let url = URL(string: "\(API_URL)\(API_REMOVE_POST)\(postId)") else {return}
        guard let request = Request(url: url, httpMethod: "DELETE", body: nil) else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    completed()
                }
            } 
        }.resume()
    }
}
