//
//  SignUpViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 09.07.2022.
//

import SwiftUI

enum StepSignUp {
    case enterLogin
    case enterEmailAndPassword
    case enterCode
}

class SignUpViewModel: ObservableObject {
    
    @Published var load: Bool = false
    @Published var login: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmationId: String = ""
    @Published var stepSingUp: StepSignUp = .enterLogin
    
    @Published var alert: AlertModel = AlertModel(title: "", message: "", show: false)
    
    func signIn () -> Void {
        if self.email.isEmpty && self.password.isEmpty {
            self.alert = AlertModel(title: "Ошибка", message: "Что-то пошло не так, попробуйте еще раз.", show: true)
            return
        }
        
        guard let url = URL(string: "\(API_URL)\(API_AUTH)") else {return}
        let body: [String: String] = ["email": self.email, "password": self.password.toBase64(), "device": UIDevice.current.name]
        guard let request = Request(url: url, httpMethod: "POST", body: body) else {return}
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            if response.statusCode == 200 {
                guard let user = try? JSONDecoder().decode(UserModel.self, from: data) else { return }
                DispatchQueue.main.async {
                    UserDefaults.standard.set(user.token, forKey: "token")
                    UserDefaults.standard.set(user.user.id, forKey: "userId")
                    NotificationCenter.default.post(name: NSNotification.Name("userId"), object: nil)
                    self.login = ""
                    self.email = ""
                    self.password = ""
                    self.confirmationId = ""
                    self.stepSingUp = .enterLogin
                    self.load = false
                }
            }
        }.resume()
    }
    
    func checkExistLogin (completion: @escaping (Bool?) -> Void) -> Void {
        if self.login.isEmpty {
            self.alert = AlertModel(title: "Ошибка", message: "Введите логин", show: true)
            return
        }
        guard let url = URL(string: "\(API_URL)\(API_CHECK_LOGIN)\(self.login)") else {return}
        
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            
            guard let debugJson = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            print(debugJson)
            
            debugPrint("response \(response)")
            
            if response.statusCode == 200 {
                guard let json = try? JSONDecoder().decode(ResponseResult.self, from: data) else {return}
                DispatchQueue.main.async {
                    completion(json.result)
                }
            }
        }.resume()
    }
    
    func checkExistEmail (completion: @escaping (Bool?) -> Void) -> Void {
        if self.email.isEmpty {
            self.alert = AlertModel(title: "Ошибка", message: "Введите email", show: true)
            return
        }
        guard let url = URL(string: "\(API_URL)\(API_CHECK_EMAIL)\(self.email)") else {return}
        
        guard let request = Request(url: url, httpMethod: "GET", body: nil) else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            
            if response.statusCode == 200 {
                guard let json = try? JSONDecoder().decode(ResponseResult.self, from: data) else {return}
                
                DispatchQueue.main.async {
                    completion(json.result)
                }
            }
        }.resume()
    }
    
    func sendConfirmCode () -> Void {
        if self.email.isEmpty {
            self.alert = AlertModel(title: "Ошибка", message: "Введите email", show: true)
            return
        }
        self.load = true
        self.checkExistEmail { exist in
            guard let exist = exist else {return}
            if exist {
                self.load = false
                self.alert = AlertModel(title: "Ошибка", message: "Этот Email уже занят, выберите другой.", show: true)
            } else {
                guard let url = URL(string: "\(API_URL)\(API_SEND_CONFIRM_CODE)") else {return}
                let body: [String: String] = ["email": self.email]

                guard let request = Request(url: url, httpMethod: "POST", body: body) else {return}

                URLSession.shared.dataTask(with: request) { data, response, _ in

                    guard let response = response as? HTTPURLResponse else {return}
                    guard let data = data else {return}

                    if response.statusCode == 200 {
                        guard let json = try? JSONDecoder().decode(SendConfirmCodeResponse.self, from: data) else {return}
                        DispatchQueue.main.async {
                            self.confirmationId = json.id
                            self.load = false
                            self.stepSingUp = .enterCode
                        }
                    }
                }.resume()
            }
        }
    }
    
    func confirm (code: String, completion: @escaping (Bool?) -> Void) -> Void {
        if self.confirmationId.isEmpty {
            self.alert = AlertModel(title: "Ошибка", message: "Что-то пошло не так, попробуйте еще раз.", show: true)
            return
        }
        if code.isEmpty || code.count < 4 {
            self.alert = AlertModel(title: "Ошибка", message: "Вы ввели не верный код.", show: true)
            return
        }
        
        self.load = true
        
        guard let url = URL(string: "\(API_URL)\(API_EMAIL_CONFIRM)") else {return}
        let body: [String: String] = ["confirmationId": self.confirmationId, "code": code]
        
        guard let request = Request(url: url, httpMethod: "POST", body: body) else {return}
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            
            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            
            if response.statusCode == 200 {
                guard let json = try? JSONDecoder().decode(ResponseResult.self, from: data) else {return}
                DispatchQueue.main.async {
                    completion(json.result)
                    self.load = false
                }
            }
        }.resume()
    }
    
    func createUser () -> Void {
        if self.login.isEmpty || self.email.isEmpty || self.password.isEmpty || self.confirmationId.isEmpty {
            self.alert = AlertModel(title: "Ошибка", message: "Что-то пошло не так, попробуйте еще раз.", show: true)
            return
        }
        
        self.load = true
        
        guard let url = URL(string: "\(API_URL)\(API_SIGN_UP)") else {return}
        let body: [String: String] = ["login": login, "email": email, "password": password.toBase64(), "confirmationId": confirmationId]
        
        guard let request = Request(url: url, httpMethod: "POST", body: body) else {return}
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            
            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    self.signIn()
                }
            }
        }.resume()
    }
}
