//
//  CreateNewChatView.swift
//  scrollo
//
//  Created by Artem Strelnik on 26.08.2022.
//

import SwiftUI
import Introspect
import SDWebImageSwiftUI

struct CreateNewChatView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @StateObject var messangerViewModel : MessangerViewModel = MessangerViewModel()
//    @State var findUser: String = ""
    
    var body: some View {
        VStack {
//            HeaderBar()
//            VStack(alignment: .leading){
//                Text("Кому: ")
//                    .font(.custom(GothamBold, size: 14))
//                    .foregroundColor(Color(hex: "#2E313C"))
//                TextField("Поиск", text: $findUser)
//            }
//            .padding(.horizontal)
//            .padding(.bottom)
//            ScrollView(showsIndicators: false) {
//                if (!messangerViewModel.load) {
//                    ProgressView()
//                } else {
//                    ForEach(0..<messangerViewModel.followers.count, id: \.self){index in
//                        Button(action: {
//                            messangerViewModel.createChat(userId: messangerViewModel.followers[index].followOnUser.id) { res in
//                                if (res == true) {
//                                    presentationMode.wrappedValue.dismiss()
//                                }
//                            }
//                        }) {
//                            HStack(alignment: .top) {
//                                if let avatar = messangerViewModel.followers[index].followOnUser.avatar {
//                                    WebImage(url: URL(string: "\(API_URL)/uploads/\(avatar)")!)
//                                        .resizable()
//                                        .frame(width: 56, height: 56)
//                                        .cornerRadius(16)
//                                } else {
//                                    UIDefaultAvatar(width: 56, height: 56, cornerRadius: 16)
//                                }
//
//                                VStack(alignment: .leading) {
//                                    Text(messangerViewModel.followers[index].followOnUser.login ?? "")
//                                        .font(.custom(GothamBold, size: 14))
//                                        .foregroundColor(Color(hex: "#2E313C"))
//    //                                Text("@login")
//    //                                    .font(.custom(GothamBook, size: 14))
//    //                                    .foregroundColor(Color(hex: "#2E313C"))
//                                }
//                                Spacer()
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//            }
        }
        .onAppear {
//            messangerViewModel.getFollowers()
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
