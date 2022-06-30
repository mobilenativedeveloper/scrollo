//
//  SignUpView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

struct SignUpView : View {
    @ObservedObject var keyboardHelper = KeyboardHelper()
    @StateObject var otpViewModel = OTPViewModel()
    @State var login: String = String()
    @State var email: String = String()
    @State var password: String = String()
    @State var stepSingUp: StepSignUp = .enterLogin
    @State var error: Bool = false
    @State var errorMessage: String = String()
    
    var body : some View {
        
        ZStack(alignment: .center) {
            
            Color.white.ignoresSafeArea(.all)
                .overlay(
                    
                    Image("logo_large")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 4)
                        .offset(y: -((UIScreen.main.bounds.height / 4) / 1.5))
                    ,alignment: .center
                )
                .overlay(
                    
                    VStack(spacing: 0) {
                        if self.stepSingUp == .enterLogin {
                            
                            Text("шаг №1")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(.top, 32)
                                .padding(.bottom, 18)
                            Text("Регистрация")
                                .font(.system(size: 27))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom, 16)
                            Text("Выберите имя вашего аккаунта")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            
                            Spacer(minLength: 0)
                            
                            TextFieldLogin(value: self.$login, placeholder: "Аккаунт")
                            
                            Spacer(minLength: 0)
                            
                            Button(action: {
                                if !self.login.isEmpty {
                                    self.stepSingUp = .enterEmailAndPassword
                                } else {
                                    self.errorMessage = "Поле логин не должно быть пустым"
                                    self.error.toggle()
                                }
                            }) {
                                Text("Далее")
                                    .foregroundColor(.white)
                                    .padding()

                            }
                            .frame(width: 140, height: 56, alignment: .center)
                            .background(Color(hex: "#36D1DC"))
                            .cornerRadius(18.0)
                            .padding(.bottom, 49)
                        }
                        
                        if self.stepSingUp == .enterEmailAndPassword {
                            
                            Text("шаг №2")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(.top, 32)
                                .padding(.bottom, 18)
                            Text("Регистрация")
                                .font(.system(size: 27))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom, 16)
                            Text("Введите ваше e-mail и придумайте пароль")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            
                            Spacer(minLength: 0)
                            
                            TextFieldLogin(value: self.$email, placeholder: "E-mail")
                                .padding(.bottom, 14)
                            TextFieldLogin(value: self.$password, placeholder: "Пароль", secure: true)
                            
                            Spacer()
                            
                            Button(action: {
                                self.sendCode()
                            }) {
                                Text("Далее")
                                    .foregroundColor(.white)
                                    .padding()

                            }
                            .frame(width: 140, height: 56, alignment: .center)
                            .background(Color(hex: "#36D1DC"))
                            .cornerRadius(18.0)
                            .padding(.bottom, 49)
                        }
                        
                        if self.stepSingUp == .enterCode {
                            
                            Text("шаг №3")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(.top, 32)
                                .padding(.bottom, 18)
                            Text("Регистрация")
                                .font(.system(size: 27))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom, 16)
                            Text("Введите код аутентификации")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            
                            Spacer(minLength: 0)
                            
                            OTPField(otpField: $otpViewModel.otpField, otp1: otpViewModel.otp1, otp2: otpViewModel.otp2, otp3: otpViewModel.otp3, otp4: otpViewModel.otp4, isTextFieldDisabled: otpViewModel.isTextFieldDisabled)
                            
                            Spacer()
                            
                            Button(action: {
                                self.confirm()
                            }) {
                                Text("Создать аккаунт")
                                    .foregroundColor(.white)
                                    .padding()

                            }
                            .frame(width: 140, height: 56, alignment: .center)
                            .background(Color(hex: "#36D1DC"))
                            .cornerRadius(18.0)
                            .padding(.bottom, 49)
                        }
                    }
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 1.9)
                        .background(
                            Color(hex: "#5B86E5")
                                .clipShape(CustomCorner(radius: 20, corners: [.topLeft, .topRight]))
                        )
                    ,alignment: .bottom
                )
        }
        .offset(y: -self.keyboardHelper.keyboardHeight)
        .animation(.spring())
        .ignoresSafeArea(.all)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .alert(isPresented: self.$error) {
            Alert(title: Text("Ошибка"), message: Text(self.errorMessage), dismissButton: .default(Text("Продолжить")))
        }
    }
    
    private func sendCode () -> Void {
        
        if !self.email.isEmpty && !self.password.isEmpty {
            //MARK: This is send code
            self.stepSingUp = .enterCode
        } else {
            self.errorMessage = "Заполните все поля"
            self.error.toggle()
        }
    }
    
    private func confirm () -> Void {
        if otpViewModel.otpField.count == 4 {
            
        } else {
            
            self.errorMessage = "Введите код"
            self.error.toggle()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

enum StepSignUp {
    case enterLogin
    case enterEmailAndPassword
    case enterCode
}
