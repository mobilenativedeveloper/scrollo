//
//  ActivitiesView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActionsView: View {
    @StateObject var actions: ActionViewModel = ActionViewModel()
    @State private var selection: String = "Вы"
    private let tabs: [String] = ["Вы", "Запросы"]
    
    var body: some View {
        VStack {
            self.tabsHeader()
            VStack {
                TabView(selection: self.$selection) {
                    VStack {
                        if actions.load {
                            if actions.actions.count > 0 {
                                HStack {
                                    Text("сегодня")
                                        .font(.system(size: 18))
                                        .bold()
                                        .textCase(.uppercase)
                                        .foregroundColor(Color(hex: "#2E313C"))
                                        .padding(.top, 16)
                                        .padding(.bottom, 18)
                                        .padding(.horizontal, 19)
                                    Spacer()
                                }
                                ForEach(0..<actions.actions.count, id: \.self){index in
                                    ActionView(action: actions.actions[index])
                                        .environmentObject(actions)
                                }
                            } else {
                                VStack(alignment: .center) {
                                    Text("Здесь будут показываться ваши cобытия.")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                        .padding(.horizontal, 40)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .refreshableCompat(
                        showsIndicators: false, onRefresh: { done in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                actions.getActions {
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
                    .tag("Вы")
                    
                    ScrollView(showsIndicators: false) {
                        
                    }.tag("Запросы")
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: Alignment(horizontal: .leading, vertical: .top))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: Alignment(horizontal: .leading, vertical: .top))
        .background(Color(hex: "#F9F9F9").ignoresSafeArea(.all))
    }
    
    @ViewBuilder
    private func tabsHeader() -> some View {
        HStack(spacing: 0) {
            ForEach(0..<self.tabs.count, id: \.self) {index in
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    Button(action: {
                        withAnimation(.default) {
                            self.selection = self.tabs[index]
                        }
                    }) {
                        Text(self.tabs[index])
                            .font(.custom(self.selection == self.tabs[index] ? GothamBold : GothamBook, size: 13))
                            .textCase(.uppercase)
                            .foregroundColor(Color(hex: self.selection == self.tabs[index] ? "#5B86E5" :  "#333333"))
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / CGFloat(self.tabs.count) - 32))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "#5B86E5").opacity(self.selection == self.tabs[index] ? 1 : 0))
                        .frame(width: (UIScreen.main.bounds.width / CGFloat(self.tabs.count) - 32), height: 3)
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
}

//MARK: Actions
private struct ActionView: View{
    @EnvironmentObject var actions: ActionViewModel
    @State var isFollow: Bool = false
    var action: ActionResponse.ActionModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
//            ActionAvatar(userId: action.creator.id, avatar: action.creator.avatar)
            if let avatar = action.creator.avatar {
                WebImage(url: URL(string: "\(API_URL)/uploads/\(avatar)")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .cornerRadius(10)
            } else {
                UIDefaultAvatar(width: 44, height: 44, cornerRadius: 10)
                    .padding(.trailing, 16)
            }
            Group {
                Text("\(action.creator.login)").font(.custom(GothamBold, size: 14)) + Text(" ") + Text(getActionString()).font(.custom(GothamBook, size: 12)).foregroundColor(Color(hex: "#2E313C")) + Text(" ") + Text("6д").font(.custom(GothamBold, size: 12)).foregroundColor(Color(hex: "#828796"))
            }
            .padding(.horizontal, 11)
    
            Spacer()
            
            if (action.action == "SENT_FOLLOW_REQUEST" || action.action == "FOLLOW") {
                Button(action: {
                    if (!isFollow) {
                        actions.followOnUser(userId: action.creator.id) { 
                            self.isFollow = true
                        }
                    }
                }) {
                    Text(!isFollow ? "Подписаться" : "Написать").font(.custom(GothamBold, size: 10)).foregroundColor(!isFollow ? Color.white : Color(hex: "#444A5E"))
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 9).fill(!isFollow ? Color(hex: "#5B86E5") : Color.clear))
                .background(
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(!isFollow ? Color(hex: "#5B86E5") : Color(hex: "#DDE8E8"), lineWidth: 1)
                    )
            }
        
            
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(action.action == "SENT_FOLLOW_REQUEST" || action.action == "FOLLOW" ? Color.white : Color.clear)
        .cornerRadius(10)
        .padding(.bottom)
        .onAppear {
            actions.checkFollowOnUser(userId: action.creator.id) { follow in
                if (follow == true) {
                    isFollow = true
                } else {
                    isFollow = false
                }
                
            }
        }
    }
    

    func getActionString () -> String {
        switch action.action {
            case "SENT_FOLLOW_REQUEST":
                return "отправил вам запрос на подписку"
            case "COMMENT_REPLY":
                return "ответил на ваш комментарий"
            case "POST_DISLIKE":
                return "не нравится ваша публикация"
            case "COMMENT_DISLIKE":
                return "не нравится ваш комментарий"
            case "ACCEPT_FOLLOW_REQUEST":
                return "принял ваш запрос"
            case "POST_COMMENT":
                return "прокомментировал вашу публикацию"
            case "COMMENT_LIKE":
                return "нравится ваш комментарий"
            case "POST_LIKE":
                return "нравится ваша публикация"
            default:
                return "подписался(-ась) на ваши обновления"
        }
    }
}

//struct ActionAvatar: View {
//    var avatar: String?
//    var userId: String
//    var body: some View {
//        if let avatar = avatar {
//            NavigationLink(destination: ProfileView(userId: userId)
//                            .ignoresSafeArea(SafeAreaRegions.container, edges: .bottom)
//                            .ignoreDefaultHeaderBar) {
//                Image("testUserPhoto")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 44, height: 44)
//                    .cornerRadius(10)
//            }
//
//        } else {
//            NavigationLink(destination: ProfileView(userId: userId)
//                            .ignoresSafeArea(SafeAreaRegions.container, edges: .bottom)
//                            .ignoreDefaultHeaderBar) {
//                UIDefaultAvatar(width: 44, height: 44, cornerRadius: 10)
//                    .padding(.trailing, 16)
//            }
//        }
//    }
//}
