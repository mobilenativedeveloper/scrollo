//
//  Request.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

func Request (url: URL, httpMethod: String, body: [String: Any]?) -> URLRequest? {
    let token = UserDefaults.standard.string(forKey: "token")
    
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    if let token = token {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    if let body = body {
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
    }
    
    return request
}

