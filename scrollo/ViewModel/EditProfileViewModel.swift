//
//  EditProfileViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 07.07.2022.
//

import SwiftUI

class EditProfileViewModel: ObservableObject {
    
    @Published var avatar: String? = nil
    @Published var background: String? = nil
    @Published var name: String = ""
    @Published var login: String = ""
    @Published var career: String = ""
    @Published var website: String = ""
    @Published var bio: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var genderSelection: String = ""
    
    @Published var load: Bool = false
    @Published var loadEdit: Bool = false
    
    @Published var alert: Bool = false
    @Published var alertMessage: String = ""
    @Published var alertTitle: String = ""
    
    
    
    init () {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {return}
        
        self.getProfile(userId: userId)
    }
    
    func getProfile (userId: String) -> Void {
        
        let url = URL(string: "\(API_URL)\(API_GET_USER)\(userId)")!
        
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) {data, response, _ in
            
            
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            
            if response.statusCode == 200 {
                guard let json = try? JSONDecoder().decode(UserModel.User.self, from: data) else {return}
                DispatchQueue.main.async {
                    self.avatar = json.avatar
                    self.background = json.background
                    self.name = json.personal?.name ?? ""
                    self.login = json.login!
                    self.career = json.career ?? ""
                    self.website = json.personal?.website ?? ""
                    self.bio = json.personal?.bio ?? ""
                    self.email = json.email ?? ""
                    self.phone = json.phone ?? ""
                    if json.personal?.gender == "F" {
                        self.genderSelection = "Женский"
                    } else {
                        self.genderSelection = "Мужской"
                    }
                    self.load = true
                }
            }
        }.resume()
    }
    
    func editProfile (onSuccess: @escaping() -> Void) -> Void {
        if self.login.isEmpty {
            self.alertTitle = "Ошибка"
            self.alertMessage = "Логин не должен быть пустым"
            self.alert.toggle()
            return
        }
        if self.email.isEmpty {
            self.alertTitle = "Ошибка"
            self.alertMessage = "Email не должен быть пустым"
            self.alert.toggle()
            return
        }
        if self.phone.count != 16 && !self.phone.isEmpty {
            self.alertTitle = "Ошибка"
            self.alertMessage = "Введите правильный номер телефона"
            self.alert.toggle()
            return
        }
        self.loadEdit = true
        let url = URL(string: "\(API_URL)\(API_EDIT_USER)")!
        
        let body: [String: String] = [
            "name": self.name,
            "login": self.login,
            "email": self.email,
            "phone": self.phone,
            "bio": self.bio,
            "gender": self.genderSelection == "Женский" ? "F" : "M",
            "website": self.website,
            "career": self.career
        ]
        
        guard let request = Request(url: url, httpMethod: "PATCH", body: body) else {return}
        
        URLSession.shared.dataTask(with: request){data, response, error in
            if let _ = error {
                return
            }

            guard let response = response as? HTTPURLResponse else {return}

            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    onSuccess()
                    self.loadEdit = false
                }
            } else {
                DispatchQueue.main.async {
                    self.loadEdit = false
                    self.alertTitle = "Ошибка"
                    self.alertMessage = "Произошла ошибка, попробуйте пзже"
                    self.alert.toggle()
                    return
                }
            }

        }.resume()
    }
    
    func updateUserBackground (background: UIImage, onSuccess: @escaping() -> Void) -> Void {
        let url = URL(string: "\(API_URL)\(API_UPDATE_USER_BACKGROUND)")!
        let token = UserDefaults.standard.string(forKey: "token")
        if let token = token {
            let boundary = generateBoundary()
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PATCH"
            guard let image = background.jpegData(compressionQuality: 0.7) else {return}
            let mediaImage = MultipartMedia(key: "background", filename: "imagefile.jpg", data: image, mimeType: "image/jpeg")
            let dataBody = createDataBody(withParameters: nil, media: [mediaImage], boundary: boundary)
            request.httpBody = dataBody
            let session = URLSession.shared
              session.dataTask(with: request) { (data, response, error) in
                  if let _ = error {
                      return
                  }
                  
                  guard let response = response as? HTTPURLResponse else {return}
                  
                  if response.statusCode == 200 {
                      DispatchQueue.main.async {
                          onSuccess()
                      }
                  } else {
                      self.alertTitle = "Ошибка"
                      self.alertMessage = "Не удалось изменить фон"
                      self.alert.toggle()
                      return
                  }
              }.resume()
            
            
        }
    }
    
    func updateUserAvatar (avatar: UIImage, onSuccess: @escaping() -> Void) -> Void {
        let url = URL(string: "\(API_URL)\(API_UPDATE_USER_AVATAR)")!
        let token = UserDefaults.standard.string(forKey: "token")
        if let token = token {
            let boundary = generateBoundary()
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PATCH"
            
            guard let image = avatar.jpegData(compressionQuality: 0.7) else {return}
            let mediaImage = MultipartMedia(key: "avatar", filename: "imagefile.jpg", data: image, mimeType: "image/jpeg")
            
            let dataBody = createDataBody(withParameters: nil, media: [mediaImage], boundary: boundary)
            request.httpBody = dataBody
            let session = URLSession.shared
              session.dataTask(with: request) { (data, response, error) in
                  if let _ = error {
                      return
                  }
                  
                  guard let response = response as? HTTPURLResponse else {return}
                  
                  if response.statusCode == 200 {
                      DispatchQueue.main.async {
                          onSuccess()
                      }
                  } else {
                      self.alertTitle = "Ошибка"
                      self.alertMessage = "Не удалось изменить фото"
                      self.alert.toggle()
                      return
                  }
              }.resume()
            
            
        }
    }
}
