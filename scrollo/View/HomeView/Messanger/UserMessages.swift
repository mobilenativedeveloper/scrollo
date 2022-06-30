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
            
            
            List {
                ForEach(0..<30, id: \.self) {index in
                    
                    UIFromMessage()
                        .ignoreListAppearance()
                    UIFromMessage()
                        .ignoreListAppearance()
                    UIFromMessage()
                        .ignoreListAppearance()
                    UIToMessage()
                        .ignoreListAppearance()
                }
            }
            .listStyle(.plain)
            .padding(.horizontal)
            
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
                    Button(action: {
                        
                    }) {
                        Image("image")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.trailing, 8)
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

struct UserMessages_Previews: PreviewProvider {
    static var previews: some View {
        UserMessages()
    }
}


private struct UIFromMessage : View {
    
    var body : some View {
        
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            Text("While more and more services and products are evolving into digital products.How to represent a brand in your UI becomes a")
                .font(.custom(GothamBook, size: 12))
                .foregroundColor(.white)
                .padding(.all, 11)
                .frame(maxWidth: UIScreen.main.bounds.width - 100)
                .background(Color(hex: "#5B86E5"))
                .clipShape(CustomCorner(radius: 10, corners: [.topLeft, .bottomLeft, .bottomRight]))
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
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
            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: UIScreen.main.bounds.width - 100)
        .padding(.horizontal)
    }
}
