//
//  MessageListView.swift
//  scrollo
//
//  Created by Artem Strelnik on 25.06.2022.
//

import SwiftUI

struct MessangerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var messangerViewModel : MessangerViewModel = MessangerViewModel()
    @State private var searchText : String = String()
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            //MARK: HeaderBar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("circle.left.arrow")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fill)
                }
                Spacer(minLength: 0)
                VStack(spacing: 4) {
                    Text("lana_smith")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#828796"))
                    Text("Сообщения")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .foregroundColor(Color(hex: "#2E313C"))
                }
                Spacer(minLength: 0)
                Image("new.message")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .aspectRatio(contentMode: .fill)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            List {
                
                //MARK: Search chat View
                HStack(spacing: 0) {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                        .padding(.trailing, 13)
                    TextField("Найти чат", text: self.$searchText)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color(hex: "#ececec").opacity(0.5), radius: 30, x: 0, y: 0)
                .padding(.horizontal)
                .padding(.top, 25)
                .padding(.bottom, 30)
                .ignoreListAppearance()
                
                //MARK: Favorites contacts
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Избранные контакты")
                        .font(.custom(GothamMedium, size: 16))
                        .foregroundColor(Color(hex: "#4F4F4F"))
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<12, id: \.self) {_ in
                                UIFavoriteContactView()
                                    .overlay(
                                        NavigationLink(destination: UserMessages().ignoreDefaultHeaderBar, label: {
                                            EmptyView()
                                        }).opacity(0)
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 35)
                .ignoreListAppearance()
                
                //MARK: Chat list
                VStack(spacing: 13) {
                    ForEach(0..<self.messangerViewModel.chats.count, id: \.self) {index in
//                        UIUserMessageView(message: self.messageViewModel.userMessageList[index])
//                            .overlay(
//                                NavigationLink(destination: UserMessages().ignoreDefaultHeaderBar, label: {
//                                    EmptyView()
//                                }).opacity(0)
//                            )
                    }
                }
                .padding(.horizontal)
                .ignoreListAppearance()
            }
            .listStyle(.plain)
            
        }
        .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
    }
}

struct MessangerView_Previews: PreviewProvider {
    static var previews: some View {
        MessangerView()
    }
}

private struct UIFavoriteContactView : View {
    
    var body : some View {
        VStack(spacing: 0) {
            
            ZStack(alignment: .bottomTrailing) {
                
                Image("testUserPhoto")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.bottom, 8)
                
                Circle()
                    .fill(Color(hex: "#38DA7C"))
                    .frame(width: 13, height: 13)
                    .offset(x: 2, y: -9)
            }
            
            Text("Jessica")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#4F4F4F"))
        }
    }
}

private struct UIUserMessageView : View {
    
    let message : UserMessageModel
    
    init (message: UserMessageModel) {
        self.message = message
    }
    
    var body : some View {
        
        HStack(spacing: 0) {
            
            ZStack(alignment: .bottomTrailing) {
                Image(self.message.avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                if self.message.online {
                    Circle()
                        .fill(Color(hex: "#38DA7C"))
                        .frame(width: 9, height: 9)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 14, height: 14)
                        )
                        .offset(x: 2)
                } else {
                    Text("1ч")
                        .font(.custom(GothamBook, size: 10))
                        .foregroundColor(Color(hex: "#828796"))
                        .padding(.all, 2)
                        .padding(.horizontal, 4)
                        .background(Color(hex: "#DDE8E8"))
                        .cornerRadius(50)
                        .offset(x: 4)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(self.message.login)
                    .font(.custom(GothamBold, size: 14))
                    .foregroundColor(Color(hex: "#2E313C"))
                Text("See you on the next meeting! 😂")
                    .font(.custom(GothamBook, size: 14))
                    .foregroundColor(!self.message.viewed ? Color(hex: "#2E313C") : Color(hex:"#828796"))
            }
            .padding(.leading, 20)
            
            Spacer(minLength: 0)
            
            if !self.message.viewed {
                VStack(spacing: 0) {
                    
                    Text("\(self.message.time) мин")
                        .font(.custom(GothamMedium, size: 10))
                        .foregroundColor(Color(hex: "828796"))
                        .padding(.bottom, 4)
                    Text("3")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(.all, 4)
                        .padding(.horizontal, 4)
                        .background(
                            Color(hex: "#5B86E5")
                        )
                        .cornerRadius(50)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(
            !self.message.viewed ? Color.white.clipShape(CustomCorner(radius: 15, corners: [.topLeft, .bottomLeft])) : nil
        )
        .shadow(color: Color(hex: "#778EA5").opacity(0.13), radius: 10, x: 3, y: 5)
    }
}
