//
//  CreateNewChatView.swift
//  scrollo
//
//  Created by Artem Strelnik on 26.08.2022.
//

import SwiftUI
import Introspect

struct CreateNewChatView: View {
    @State var findUser: String = ""
    
    var body: some View {
        VStack {
            HeaderBar()
            VStack(alignment: .leading){
                Text("Кому: ")
                    .font(.custom(GothamBold, size: 14))
                    .foregroundColor(Color(hex: "#2E313C"))
                TextField("Поиск", text: $findUser)
            }
            .padding(.horizontal)
            .padding(.bottom)
            ScrollView(showsIndicators: false) {
                ForEach(0..<20, id: \.self){index in
                    HStack(alignment: .top) {
                        UIDefaultAvatar(width: 56, height: 56, cornerRadius: 16)
                        VStack(alignment: .leading) {
                            Text("Name Lastname")
                                .font(.custom(GothamBold, size: 14))
                                .foregroundColor(Color(hex: "#2E313C"))
                            Text("@login")
                                .font(.custom(GothamBook, size: 14))
                                .foregroundColor(Color(hex: "#2E313C"))
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

private struct HeaderBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View{
        HStack(spacing: 0) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("circle_close")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .aspectRatio(contentMode: .fill)
            }
            Spacer(minLength: 0)
            Text("Новое сообщение")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .textCase(.uppercase)
                .foregroundColor(Color(hex: "#2E313C"))
            Spacer(minLength: 0)
            Button(action: {
              
            }) {
                Image("circle.right.arrow")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .aspectRatio(contentMode: .fill)
            }
        }
        .padding(.horizontal, 23)
        .padding(.bottom)
    }
}
