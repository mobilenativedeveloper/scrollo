//
//  ChatListView.swift
//  scrollo
//
//  Created by Artem Strelnik on 14.09.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatListView: View {
    @StateObject var chatViewModel : ChatViewModel = ChatViewModel()
    @State private var searchText : String = String()
    @State var isShowing: Bool = false
    
    @State var presentNewChat: Bool = false
    @State var pushOnNewChat: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(presentNewChat: $presentNewChat)
            VStack {
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
                .padding(.top, 15) //<--This mark
                .padding(.bottom, 15) //<--This mark
                
                // Chat list
                VStack(alignment: .leading, spacing: 13) {
                    if (chatViewModel.loadChats) {
                        if chatViewModel.chats.count > 0 || chatViewModel.favoriteChats.count > 0{
                            // Favorites chats
                            if chatViewModel.favoriteChats.count > 0{
                                Text("Избранные контакты")
                                    .font(.custom(GothamMedium, size: 16))
                                    .foregroundColor(Color(hex: "#4F4F4F"))
                                    .padding(.bottom, 9) //<--This mark
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(0..<chatViewModel.favoriteChats.count, id: \.self) {index in
                                            FavoriteContactView(chat: chatViewModel.favoriteChats[index])
                                                .environmentObject(chatViewModel)
                                        }
                                    }
                                }
                                .padding(.bottom, 5) //<--This mark
                            }
                            ForEach(0..<chatViewModel.chats.count, id: \.self) {index in
                                ChatItemView(chat: $chatViewModel.chats[index], chatList: $chatViewModel.chats)
                                    .environmentObject(chatViewModel)
                            }
                        }
                        else{
                            Image(systemName: "text.bubble.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .padding(.top, 100)
                        }
                    } else {
                        ProgressView()
                    }
                }
                .padding(.horizontal)
            }
            .refreshableCompat(
                showsIndicators: false, onRefresh: { done in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        chatViewModel.getChats {
                            done()
                        }
                    }
                },
                progress: { state in
                    RefreshActivityIndicator(isAnimating: state == .loading) {
                        $0.hidesWhenStopped = false
                    }
                }
            )
        }
        .background(
            NavigationLink(destination: ChatMessagesView().ignoreDefaultHeaderBar, isActive: $pushOnNewChat, label: {
                EmptyView()
            })
        )
        .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
        .overlay{
            if presentNewChat {
                CreateNewChatView(presentNewChat: $presentNewChat) { newChat in
                    chatViewModel.chats.append(newChat)
                    withAnimation(.easeInOut(duration: 0.3)){
                        presentNewChat.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        pushOnNewChat.toggle()
                    }
                }
            }
        }
        .onAppear {
            
            chatViewModel.getChats{
                
            }
        }
    }
}

private struct HeaderBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var presentNewChat: Bool
    var body: some View{
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
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)){
                    presentNewChat.toggle()
                }
            }) {
                Image("new.message")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .aspectRatio(contentMode: .fill)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}
