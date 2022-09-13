//
//  ActivitiesViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 26.08.2022.
//

import SwiftUI

class ActionViewModel: ObservableObject {
    
    @Published var actions: [ActionsSorted] = []
    @Published var load: Bool = false
 
    var page = 0
    let pageSize = 5
    
    init () {
        getActions {
            self.load = true
        }
    }
    
    func sortedActions (dataActions: [ActionResponse.ActionModel]) -> [ActionsSorted] {
//        const date = '2022-08-29T00:00:00.000Z'
//        let currentDate = Date.parse(new Date());
//        let days = (currentDate - Date.parse(date))/86400000;       //86400000 - ms в дне
//        console.log(Math.round(days))
        var res: [ActionsSorted] = []
        dataActions.forEach { action in
            let currentDate = Date()
            let actionDate = action.createdAt.split(separator: ".")[0] + "+" + action.createdAt.split(separator: "+")[1]
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: String(actionDate))!
            

            
            let datesBetweenArray = Date.dates(from: currentDate, to: date)
            
            if (datesBetweenArray.count == 0) {
                if let index = res.firstIndex(where: {$0.title == "Сегодня"}) {
                    res[index].data.append(action)
                } else {
                    res.append(ActionsSorted(title: "Сегодня", data: [action]))
                }
            } else if (datesBetweenArray.count == 1) {
                if let index = res.firstIndex(where: {$0.title == "Вчера"}) {
                    res[index].data.append(action)
                } else {
                    res.append(ActionsSorted(title: "Вчера", data: [action]))
                }
            } else if (datesBetweenArray.count == 2) {
                if let index = res.firstIndex(where: {$0.title == "Позавчера"}) {
                    res[index].data.append(action)
                } else {
                    res.append(ActionsSorted(title: "Позавчера", data: [action]))
                }
            } else if (datesBetweenArray.count == 7) {
                if let index = res.firstIndex(where: {$0.title == "Эта неделя"}) {
                    res[index].data.append(action)
                } else {
                    res.append(ActionsSorted(title: "Эта неделя", data: [action]))
                }
            } else {
                if let index = res.firstIndex(where: {$0.title == "Ранее"}) {
                    res[index].data.append(action)
                } else {
                    res.append(ActionsSorted(title: "Ранее", data: [action]))
                }
            }
        }
        return res
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
                    
                    self.actions = self.sortedActions(dataActions: json.data)
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


extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
