//
//  FollowersViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 16.09.2022.
//

import SwiftUI

class FollowersViewModel: ObservableObject{
    var load: Bool = false
    
    var followers: [FollowersResponse.FollowerModel] = []
    
    @Published var page = 0
    let pageSize = 100
    
    func getFollowers () {
        guard let url = URL(string: "\(API_URL)\(API_GET_USER_FOLLOWERS)?page=\(page)&pageSize=\(pageSize)") else {return}
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            
            if response.statusCode == 200 {
                guard let json = try? JSONDecoder().decode(FollowersResponse.self, from: data) else {return}
                DispatchQueue.main.async {
                    self.followers = json.data
                    self.load = true
                }
            }
        }
        .resume()

    }
}
