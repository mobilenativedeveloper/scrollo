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
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderBar()
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
                .padding(.top, 25)
                .padding(.bottom, 30)
                
                // Favorites chats
                if chatViewModel.favoriteChats.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Избранные контакты")
                            .font(.custom(GothamMedium, size: 16))
                            .foregroundColor(Color(hex: "#4F4F4F"))
                            .padding(.horizontal)
                            .padding(.bottom, 15)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(0..<chatViewModel.favoriteChats.count, id: \.self) {index in
                                    FavoriteContactView(favoriteChatList: $chatViewModel.favoriteChats, chat: chatViewModel.favoriteChats[index])
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 35)
                }
                
                // Chat list
                VStack(spacing: 13) {
                    if (chatViewModel.loadChats) {
                        ForEach(0..<chatViewModel.chats.count, id: \.self) {index in
                            ChatItemView(chat: $chatViewModel.chats[index], chatList: $chatViewModel.chats)
                                .environmentObject(chatViewModel)
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
        .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
        .onAppear {
            chatViewModel.getChats {}
        }
    }
}

private struct HeaderBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var newChat: Bool = false
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
                newChat.toggle()
            }) {
                Image("new.message")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .aspectRatio(contentMode: .fill)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
//        .fullScreenCover(isPresented: $newChat, onDismiss: {}) {
//            CreateNewChatView()
//        }
    }
}
