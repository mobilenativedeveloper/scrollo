//
//  MessageListView.swift
//  scrollo
//
//  Created by Artem Strelnik on 25.06.2022.
//

import SwiftUI
import Introspect
import SDWebImageSwiftUI

struct MessangerView: View {
    
    @StateObject var messangerViewModel : MessangerViewModel = MessangerViewModel()
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
                if messangerViewModel.favoriteChats.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Избранные контакты")
                            .font(.custom(GothamMedium, size: 16))
                            .foregroundColor(Color(hex: "#4F4F4F"))
                            .padding(.horizontal)
                            .padding(.bottom, 15)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(0..<messangerViewModel.favoriteChats.count, id: \.self) {index in
                                    UIFavoriteContactView(favoriteChatList: $messangerViewModel.favoriteChats, chat: messangerViewModel.favoriteChats[index])
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 35)
                }
                
                // Chat list
                VStack(spacing: 13) {
                    if (messangerViewModel.loadChats) {
                        ForEach(0..<messangerViewModel.chats.count, id: \.self) {index in
                            ChatItem(chat: $messangerViewModel.chats[index], chatList: $messangerViewModel.chats)
                                .environmentObject(messangerViewModel)
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
                        
                        messangerViewModel.getChats {
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
            messangerViewModel.getChats {
                
            }
        }
    }
}

private struct ChatItem: View{
    @EnvironmentObject var messangerViewModel: MessangerViewModel
    @State var offset: CGFloat = .zero
    @State var isSwiped: Bool = false
    @Binding var chat: ChatListModel.ChatModel
    @Binding var chatList: [ChatListModel.ChatModel]
    
    var body: some View {
        NavigationLink(destination: UserMessages().ignoreDefaultHeaderBar) {
            ZStack {
                LinearGradient(gradient: .init(colors: [Color(hex: "#f55442"), Color(hex: "#fa6c5c")]), startPoint: .trailing, endPoint: .leading)
                    .clipShape(CustomCorner(radius: 15, corners: [.topLeft, .bottomLeft]))
                
                HStack{
                    Spacer(minLength: 90)
                    Button(action: {
                        withAnimation(.easeInOut) {
                            deleteItem()
                        }
                    }){
                        Image(systemName: "trash")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 90, height: 70)
                    }
                }
                .padding(.trailing, 90)
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut){
                            addFavoriteChat()
                        }
                    }){
                        Image(systemName: "star.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 90, height: 70)
                    }
                    .background(Color(hex: "#36DCD8"))
                }
                
                
                
                HStack(spacing: 0) {
                    ZStack(alignment: .bottomTrailing) {
                        if let avatar = chat.starter.avatar {
                            WebImage(url: URL(string: "\(API_URL)/uploads/\(avatar)")!)
                                .resizable()
                                .frame(width: 44, height: 44)
                                .cornerRadius(10)
                        } else {
                            UIDefaultAvatar(width: 44, height: 44, cornerRadius: 10)
                        }
                        Circle()
                            .fill(Color(hex: "#38DA7C"))
                            .frame(width: 9, height: 9)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 14, height: 14)
                            )
                            .offset(x: 2)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text(chat.starter.login)
                            .font(.custom(GothamBold, size: 14))
                            .foregroundColor(Color(hex: "#2E313C"))
                        Text("See you on the next meeting! 😂")
                            .font(.custom(GothamBook, size: 14))
                            .foregroundColor(Color(hex: "#2E313C"))
                    }
                    .padding(.leading, 20)
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 10)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .frame(height: 70)
                .background(Color.white.clipShape(CustomCorner(radius: 15, corners: [.topLeft, .bottomLeft])))
                .shadow(color: Color(hex: "#778EA5").opacity(0.13), radius: 10, x: 3, y: 5)
                .contentShape(Rectangle())
                .offset(x: offset)
                .gesture(DragGesture().onChanged(onChange(value:)).onEnded(onEnd(value:)))
            }
        }
        .buttonStyle(FlatLinkStyle())
        
    }
    
    func onChange(value: DragGesture.Value){
        if value.translation.width < 0 {
            if self.isSwiped {
                self.offset = value.translation.width - 180
            }
            else {
                self.offset = value.translation.width
            }
        }
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(.easeInOut) {
            if value.translation.width < 0{
                if -value.translation.width > UIScreen.main.bounds.width / 2{
                    self.offset = -1000
                    deleteItem()
                }
                else if -self.offset > 50{
                    self.isSwiped = true
                    self.offset = -180
                }
                else {
                    self.isSwiped = false
                    self.offset = 0
                }
            }
            else {
                self.isSwiped = false
                self.offset = 0
            }
        }
    }
    
    func deleteItem() {
        // messangerViewModel.removeChat(chatId: self.chat.id)
        chatList.removeAll{(item) -> Bool in
            return self.chat.id == item.id
        }
    }
    
    func addFavoriteChat(){
        messangerViewModel.favoriteChats.append(chat)
        self.isSwiped = false
        self.offset = 0
    }
}

private struct UIFavoriteContactView : View {
    @Binding var favoriteChatList: [ChatListModel.ChatModel]
    var chat: ChatListModel.ChatModel
    var body : some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomTrailing) {
                if let avatar = chat.starter.avatar {
                    WebImage(url: URL(string: "\(API_URL)/uploads/\(avatar)")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .cornerRadius(16)
                        .padding(.bottom, 8)
                } else {
                    UIDefaultAvatar(width: 56, height: 56, cornerRadius: 16)
                }
                
                Circle()
                    .fill(Color(hex: "#38DA7C"))
                    .frame(width: 13, height: 13)
                    .offset(x: 2, y: -9)
            }
            
            Text(chat.starter.login)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#4F4F4F"))
        }
        .padding(.all, 4)
        .contextMenu {
            Button(action: {
                withAnimation(.easeInOut){
                    deleteFavoriteChat()
                }
            }) {
                HStack{
                    Image(systemName: "star.slash")
                        .font(.title3)
                        .foregroundColor(.white)
                    Text("Удалить из избранного")
                }
            }
        }
    }
    
    func deleteFavoriteChat(){
        favoriteChatList.removeAll{(item) -> Bool in
            return self.chat.id == item.id
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
        .fullScreenCover(isPresented: $newChat, onDismiss: {}) {
            CreateNewChatView()
        }
    }
}
