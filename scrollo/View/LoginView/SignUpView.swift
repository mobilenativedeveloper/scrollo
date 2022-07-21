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
    @StateObject var signUp: SignUpViewModel = SignUpViewModel()
    
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
                        if signUp.stepSingUp == .enterLogin {
                            
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
                            
                            TextFieldLogin(value: $signUp.login, placeholder: "Аккаунт")
                            
                            Spacer(minLength: 0)
                            
                            Button(action: {
                                if signUp.login.isEmpty {
                                    signUp.alert = AlertModel(title: "Ошибка", message: "Логин не должен быть пустым.", show: true)
                                } else {
                                    signUp.load = true
                                    signUp.checkExistLogin { exist in
                                        guard let exist = exist else {return}
                                        if exist {
                                            signUp.alert = AlertModel(title: "Ошибка", message: "Этот логин уже занят, выберите другой.", show: true)
                                            signUp.load = false
                                        } else {
                                            signUp.load = false
                                            signUp.stepSingUp = .enterEmailAndPassword
                                        }
                                    }
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
                        
                        if signUp.stepSingUp == .enterEmailAndPassword {
                            
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
                            
                            TextFieldLogin(value: $signUp.email, placeholder: "E-mail")
                                .padding(.bottom, 14)
                            TextFieldLogin(value: $signUp.password, placeholder: "Пароль", secure: true)
                            
                            Spacer()
                            
                            Button(action: {
                                if signUp.email.isEmpty {
                                    signUp.alert = AlertModel(title: "Ошибка", message: "Email не должен быть пустым.", show: true)
                                } else if (signUp.password.isEmpty) {
                                    signUp.alert = AlertModel(title: "Ошибка", message: "Пароль не должен быть пустым", show: true)
                                } else {
                                    signUp.sendConfirmCode()
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
                        
                        if signUp.stepSingUp == .enterCode {
                            
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
                                signUp.confirm(code: otpViewModel.otpField) { confirmed in
                                    guard let confirmed = confirmed else {return}
                                    
                                    if confirmed {
                                        signUp.createUser()
                                    } else {
                                        signUp.alert = AlertModel(title: "Ошибка", message: "Вы ввели не верный код.", show: true)
                                    }
                                }
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
        .alert(isPresented: $signUp.alert.show) {
            Alert(title: Text(signUp.alert.title), message: Text(signUp.alert.message), dismissButton: .default(Text("Продолжить")))
        }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
