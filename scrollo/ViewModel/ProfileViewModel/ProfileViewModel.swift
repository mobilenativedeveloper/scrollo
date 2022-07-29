//
//  ProfileViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var user: UserModel.User? = nil
    
    func getProfile (userId: String) -> Void {
        
        let url = URL(string: "\(API_URL)\(API_GET_USER)\(userId)")!
        
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) {data, response, _ in
            
            
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            
            if response.statusCode == 200 {
                guard let json = try? JSONDecoder().decode(UserModel.User.self, from: data) else {return}
                DispatchQueue.main.async {
                    self.user = json
                }
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
