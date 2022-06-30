//
//  LoginView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

struct LoginView : View {
    
    var body : some View {
        ZStack(alignment: .center) {
            
            LinearGradient(gradient: Gradient(colors: [
                Color(hex: "#36DCD8"),
                Color(hex: "#5B86E5")
            ]), startPoint: .leading, endPoint: .topTrailing).ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()
                
                Image("logo_large")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 321, height: 71)
                
                Spacer()
                
                NavigationLink(destination: SignInView().ignoreDefaultHeaderBar) {
                    RoundedRectangle(cornerRadius: 18.0)
                        .fill(Color(hex: "#5B86E5"))
                        .frame(width: 258, height: 56, alignment: .center)
                        .padding()
                        .overlay(
                            Text("Войти")
                                .foregroundColor(.white)
                        )
                }
                NavigationLink(destination: SignUpView().ignoreDefaultHeaderBar) {
                    Text("Зарегистрироваться")
                        .frame(width: 258, height: 56, alignment: .center)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16).stroke(Color.white, lineWidth: 1)
                        )
                }
                
                Spacer()
                
                Group {
                    Text("Используя приложения вы соглашаетесь с ") + Text("договором оферты ").bold() + Text("и ") + Text("политикой конфеденциальности").bold()
                }
                .foregroundColor(.white)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
                .padding(.bottom)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct TextFieldLogin: View {
    @Binding var value: String
    private let placeholder: String
    private let secure: Bool
    
    public init (value: Binding<String>, placeholder: String, secure: Bool = false) {
        self._value = value
        self.placeholder = placeholder
        self.secure = secure
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white, lineWidth: 1)
            if self.secure {
                SecureField("", text: self.$value)
                    .placeholder(when: self.value.isEmpty) {
                            Text(self.placeholder).foregroundColor(.white)
                    }
                    .autocapitalization(.none)
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .padding(.horizontal)
                    .padding(.horizontal, 5)
                
            } else {
                TextField("", text: self.$value)
                    .placeholder(when: self.value.isEmpty) {
                            Text(self.placeholder).foregroundColor(.white)
                    }
                    .autocapitalization(.none)
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .padding(.horizontal)
                    .padding(.horizontal, 5)
            }
            
            
        }
        .frame(height: 56)
        .padding(.horizontal)
    }
}

struct OTPField: View {
    @Binding var otpField: String
    @State var isFocused = false
    
    var otp1: String
    var otp2: String
    var otp3: String
    var otp4: String
    var isTextFieldDisabled: Bool
    let textBoxWidth = UIScreen.main.bounds.width / 8
    let textBoxHeight = UIScreen.main.bounds.width / 8
    let spaceBetweenBoxes: CGFloat = 14
    let paddingOfBox: CGFloat = 1
    var textFieldOriginalWidth: CGFloat {
        (textBoxWidth*6)+(spaceBetweenBoxes*3)+((paddingOfBox*2)*3)
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack (spacing: spaceBetweenBoxes){
                    otpText(text: otp1)
                    otpText(text: otp2)
                    otpText(text: otp3)
                    otpText(text: otp4)
                }
                TextField("", text: $otpField)
                    .frame(width: isFocused ? 0 : textFieldOriginalWidth, height: textBoxHeight)
                    .disabled(isTextFieldDisabled)
                    .textContentType(.oneTimeCode)
                    .foregroundColor(.clear)
                    .accentColor(.clear)
                    .background(Color.clear)
                    .keyboardType(.numberPad)
            }
        }
    }
    
    private func otpText(text: String) -> some View {
              
        return Text(text)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: textBoxWidth, height: textBoxHeight)
                .background(VStack{
                    Spacer()
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#5B86E5"))
                        .frame(width: 50, height: 50)
                        .cornerRadius(10 - 1)
                        .padding(1)
                        .background(text.count == 1 ? Color(hex: "#36D1DC") : Color(hex: "#F2F2F2"))
                        .cornerRadius(10)
                    
                })
                .padding(paddingOfBox)
    }
}
