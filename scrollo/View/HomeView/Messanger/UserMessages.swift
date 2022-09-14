//
//  UserMessages.swift
//  scrollo
//
//  Created by Artem Strelnik on 25.06.2022.
//

import SwiftUI

struct UserMessages: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var message : String = String()
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("circle.left.arrow")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fill)
                }
                .padding(.trailing, 10)
                HStack(spacing: 8) {
                    Image("testUserPhoto")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .cornerRadius(8)
                        .padding(.trailing, 5)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Max Jacobson")
                            .font(.custom(GothamBold, size: 14))
                            .foregroundColor(Color(hex: "#444A5E"))
                        Text("jacobs_max")
                            .font(.custom(GothamBook, size: 12))
                            .foregroundColor(Color(hex: "#828796"))
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            GeometryReader{geometry in
                ScrollView(showsIndicators: false) {
                    VStack{
                        DetailUser()
                        
                        Spacer(minLength: 0)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight:0, maxHeight: .infinity, alignment: Alignment.topLeading)
                        
                        VStack{
                            Spacer(minLength: 0)
                            UIFromMessage()
                            WaveformView()
                            UIToMessage()
                        }
                        .padding(.horizontal)
                    }
                    
                    .frame(minHeight: geometry.size.height)
                }
                .frame(width: geometry.size.width)

            }
            
            
//            ScrollView(showsIndicators: false) {
//                VStack {
//                    Spacer()
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight:0, maxHeight: .infinity, alignment: Alignment.topLeading)
//                    ForEach(0..<30, id: \.self) {index in
//
//                        UIFromMessage()
//                        WaveformView()
//
//                        UIToMessage()
//                    }
//                }
//                .padding(.horizontal)
//                .rotationEffect(Angle(degrees: 180))
//            }
//            .rotationEffect(Angle(degrees: 180))
            
            Spacer(minLength: 0)
            
            VStack(spacing: 0) {
                
                HStack(spacing: 0) {
                    
                    TextField("Написать сообщение...", text: self.$message)
                    
                    Button(action: {
                        
                    }) {
                        Image("microphone")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.trailing, 8)
                    Menu {
                        Button(action: {
                            
                        }) {
                            HStack {
                                Text("Открыть камеру")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                    .colorMultiply(.white)
                                    .textCase(.uppercase)
                                    .padding(.vertical, 15)
                                Image(systemName: "camera")
                            }
                        }
                        Button(action: {
                            
                        }) {
                            HStack {
                                Text("Выбрать из галереи")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                    .colorMultiply(.white)
                                    .textCase(.uppercase)
                                    .padding(.vertical, 15)
                                Image(systemName: "photo")
                            }
                        }
                    } label: {
                        Button(action: {
                            
                        }) {
                            Image("image")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .padding(.trailing, 8)
                    }

                    Button(action: {
                        
                    }) {
                        Image("send")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.horizontal)
                .frame(height: 42)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "#DDE8E8"), lineWidth: 1)
                )
            }
            .padding()
            .background(Color.white)
            .overlay(
                Color(hex: "#F2F2F2")
                    .frame(height: 1)
                ,alignment: .top
            )
            .shadow(color: Color(hex: "#1e5385").opacity(0.03), radius: 10, x: 0, y: -12)
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

private struct DetailUser: View {
    var body: some View{
        VStack(spacing: 0){
            Image("testUserPhoto")
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .padding(.bottom, 6)
            Text("Name Lastname")
                .font(.system(size: 14))
                .fontWeight(.bold)
                .padding(.bottom, 3)
            Text("login • Scrollo")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#838383"))
                .padding(.bottom, 1)
            Text("Подписчики: 135 • Публикации: 0")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#838383"))
                .padding(.bottom, 8)
            NavigationLink(destination: Text("Profile").ignoreDefaultHeaderBar){
                Text("Посмотреть профиль")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 13)
                    .background(Color(hex: "#efefef").cornerRadius(8))
            }
        }
    }
}

private struct UIFromMessage : View {
    
    var body : some View {
        
        HStack(spacing: 0) {
            Spacer()
            Text("While more and more services and products are evolving into digital products.How to represent a brand in your UI becomes a")
                .font(.custom(GothamBook, size: 12))
                .foregroundColor(.white)
                .padding(.all, 11)
                .frame(maxWidth: UIScreen.main.bounds.width - 100)
                .background(Color(hex: "#5B86E5"))
                .clipShape(CustomCorner(radius: 10, corners: [.topLeft, .bottomLeft, .bottomRight]))
        }
        .padding(.vertical, 8)
    }
}

private struct UIToMessage : View {
    
    var body : some View {
        
        HStack(spacing: 0) {
            Image("testUserPhoto")
                .resizable()
                .scaledToFill()
                .frame(width: 34, height: 34)
                .cornerRadius(8)
                .clipped()
                .padding(.trailing, 17)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "F2F2F2"), lineWidth: 1)
                HStack(spacing: 0) {
                    
                    Text("Trying to make lemonade out of lemons -my homegirl Shania and I did an ‘at home’.")
                        .font(.custom(GothamBook, size: 12))
                        .foregroundColor(Color(hex: "2E313C"))
                        .frame(maxWidth: UIScreen.main.bounds.width - 100)
                }
                .padding(.all, 11)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .frame(maxWidth: UIScreen.main.bounds.width - 50)
    }
}

private struct WaveformView: View {
    let waveformPixelsPerWindow = Int(3000 / UIScreen.main.bounds.width)
    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: 2.0) {
                Image(systemName: "play.circle")
                    .foregroundColor(Color(hex: "#6F83E9"))
                    .padding(.trailing, 16)
                    .font(.title)
                ForEach(0..<20, id: \.self){index in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "#5B86E5"))
                        .frame(width: 5, height: self.getRandomHeight())
                }
                Text("00:59")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#5B86E5"))
                    .padding(.leading, 16)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color(hex: "#5B86E5").opacity(0.15))
            .cornerRadius(10)
        }
    }
    
    func getRandomHeight () -> CGFloat {
        let randomDouble = Double.random(in: 3.0...50.0)
        return randomDouble
    }
}
