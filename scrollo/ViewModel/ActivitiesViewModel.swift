//
//  ActivitiesViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 26.08.2022.
//

import SwiftUI

class ActivitiesViewModel: ObservableObject {
 
    var page = 0
    let pageSize = 5
    
    init () {
        getActions()
    }
    
    func getActions () {
        guard let url = URL(string: "\(API_URL)\(API_GET_ACTIONS)?page=\(page)&pageSize=\(pageSize)") else {return}
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                guard let data = data else {return}
//                guard let json = try? JSONDecoder().decode(PostResponse.self, from: data) else { return }
                DispatchQueue.main.async {
                    print("OK")
                }
            }
        }.resume()
    }
}
