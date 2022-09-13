//
//  ActivitiesViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 26.08.2022.
//

import SwiftUI

class ActionViewModel: ObservableObject {
    
    @Published var actions: [ActionResponse.ActionModel] = []
    @Published var load: Bool = false
 
    var page = 0
    let pageSize = 5
    
    init () {
        getActions {
            self.load = true
        }
    }
    
    func getActions (completion: @escaping () -> Void) {
        guard let url = URL(string: "\(API_URL)\(API_GET_ACTIONS)?page=\(page)&pageSize=\(pageSize)") else {return}
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                guard let data = data else {return}
                guard let debugJson = try? JSONSerialization.jsonObject(with: data, options: []) else {return}
                debugPrint(debugJson)
                guard let json = try? JSONDecoder().decode(ActionResponse.self, from: data) else { return }
                DispatchQueue.main.async {
                    
                    debugPrint(json.data)
                    self.actions = json.data
                    completion()
                }
            } else {
                debugPrint(response)
            }
        }.resume()
    }
    
    func checkFollowOnUser(userId: String, completion: @escaping (Bool?) -> Void) {
        let url = URL(string: "\(API_URL)\(API_CHECK_FOLLOW_ON_USER)\(userId)")!
        
        if let request = Request(url: url, httpMethod: "GET", body: nil) {
            URLSession.shared.dataTask(with: request){data, response, error in
                if let _ = error {
                    return
                }

                guard let response = response as? HTTPURLResponse else {return}

                if response.statusCode == 200 {
                    if let json = try? JSONDecoder().decode(ResponseResult.self, from: data!) {
                        debugPrint(json)
                        DispatchQueue.main.async {
                            if json.result == true {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        }
                    }
                }
            }.resume()
        }
    }
    
    func followOnUser(userId: String, completion: @escaping () -> Void) -> Void {
        let url = URL(string: "\(API_URL)\(API_FOLLOW_ON_USER)")!
        
        let body: [String: String] = [
            "userId": userId
        ]
        
        if let request = Request(url: url, httpMethod: "POST", body: body) {
            URLSession.shared.dataTask(with: request){data, response, error in
                if let _ = error {
                    return
                }

                guard let response = response as? HTTPURLResponse else {return}

                if response.statusCode == 200 {
                    completion()
                    print(response)
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                        print(json)
                    }
                } else {
                    print(response)
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                        print(json)
                    }
                    return
                }

            }.resume()
        }
    }
    
    func unFollowOnUser(userId: String, completion: @escaping () -> Void) -> Void {
        let url = URL(string: "\(API_URL)\(API_FOLLOW_ON_USER)\(userId)")!
        
        
        if let request = Request(url: url, httpMethod: "DELETE", body: nil) {
            URLSession.shared.dataTask(with: request){data, response, error in
                if let _ = error {
                    return
                }

                guard let response = response as? HTTPURLResponse else {return}

                if response.statusCode == 200 {
                    completion()
                    print(response)
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                        print(json)
                    }
                }
            }.resume()
        }
    }
}
