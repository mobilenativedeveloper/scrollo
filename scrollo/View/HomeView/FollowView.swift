//
//  FollowersView.swift
//  scrollo
//
//  Created by Artem Strelnik on 16.09.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct FollowView: View {
    @StateObject var followViewModel: FollowViewModel = FollowViewModel()
    
    var firstOpen: FollowTab
    var login: String
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(login: login)
            HStack(spacing: 0) {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    Button(action: {
                        followViewModel.selection = .followers
                    }) {
                        Text("\(followViewModel.followers.count) Подписчики")
                            .font(.custom(followViewModel.selection == .followers ? GothamBold : GothamBook, size: 13))
                            .textCase(.uppercase)
                            .foregroundColor(Color(hex: followViewModel.selection == .followers ? "#5B86E5" :  "#333333"))
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 2 - 32))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "#5B86E5").opacity(followViewModel.selection == .followers ? 1 : 0))
                        .frame(width: (UIScreen.main.bounds.width / 2 - 32), height: 3)
                }
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    Button(action: {
                        followViewModel.selection = .following
                    }) {
                        Text("\(followViewModel.following.count) Подписки")
                            .font(.custom(followViewModel.selection == .following ? GothamBold : GothamBook, size: 13))
                            .textCase(.uppercase)
                            .foregroundColor(Color(hex: followViewModel.selection == .following ? "#5B86E5" :  "#333333"))
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 2 - 32))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "#5B86E5").opacity(followViewModel.selection == .following ? 1 : 0))
                        .frame(width: (UIScreen.main.bounds.width / 2 - 32), height: 3)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            VStack{
                TabView(selection: $followViewModel.selection) {
                    VStack {
                        if followViewModel.loadFollowers {
                            ScrollView {
                                if followViewModel.followers.count == 0{
                                    Image("user.plue.circle.outlined")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(Color(hex: "#333333"))
                                        .padding(.bottom, 5)
                                        .padding(.top, 30)
                                    Text("Подписчики")
                                        .font(.system(size: 19))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(hex: "#333333"))
                                        .padding(.bottom, 5)
                                    Text("Здесь будут отображаться все люди, которые на вас подписаны.")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                }
                                else{
                                    ForEach(0..<followViewModel.followers.count, id: \.self) {index in
                                        let follower = followViewModel.followers[index]
                                        FollowersItemView(follow: follower)
                                            .environmentObject(followViewModel)
                                    }
                                }
                            }
                        } else {
                            ProgressView()
                        }
                    }
                    .tag(FollowTab.followers)
                    
                    VStack {
                        if followViewModel.loadFollowing{
                            ScrollView {
                                if followViewModel.following.count == 0{
                                    Image("user.plue.circle.outlined")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(Color(hex: "#333333"))
                                        .padding(.bottom, 5)
                                        .padding(.top, 30)
                                    Text("Люди, на обновления которых вы подписаны")
                                        .font(.system(size: 19))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(hex: "#333333"))
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom, 5)
                                    Text("Люди, на которых вы подпишитесь, будут отображаться здесь..")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                }
                                else{
                                    ForEach(0..<followViewModel.following.count, id: \.self) {index in
                                        let following = followViewModel.following[index]
                                        FollowingItemView(follow: following)
                                            .environmentObject(followViewModel)
                                    }
                                }
                            }
                        }
                        else{
                            ProgressView()
                        }
                    }
                    .tag(FollowTab.following)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: Alignment(horizontal: .leading, vertical: .top))
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear{
            followViewModel.selection = firstOpen
            followViewModel.getFollowers()
            followViewModel.getFollowing()
        }
    }
}

private struct HeaderBar: View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var login: String
    var body: some View{
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("circle_close")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 24)
            }
            Spacer(minLength: 0)
            Text(login)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .textCase(.uppercase)
                .foregroundColor(Color(hex: "#1F2128"))
            Spacer(minLength: 0)
            Button(action: {
               
            }) {
                Color.clear
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
}

private struct FollowersItemView : View {
    @EnvironmentObject var followViewModel: FollowViewModel
    @State var isFollowed: Bool? = nil
    var follow: FollowersResponse.FollowerModel

    var body : some View {
        HStack(alignment: .center, spacing: 0) {
            if let avatar = follow.followedUser.avatar{
                WebImage(url: URL(string: "\(API_URL)/uploads/\(avatar)")!)
                    .resizable()
                    .frame(width: 44, height: 44)
                    .cornerRadius(10)
                    .padding(.trailing, 16)
            } else {
                UIDefaultAvatar(width: 44, height: 44, cornerRadius: 10)
                    .padding(.trailing, 16)
            }

            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                Text(follow.followedUser.login!)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                Text(follow.followedUser.career ?? "")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#828796"))
                Spacer()
            }
            Spacer()
            Button(action: {
                if isFollowed == true{
                    followViewModel.unFollowOnUser(userId: follow.followedUser.id) { status in
                        if status == true{
                            withAnimation(.easeInOut){
                                isFollowed = false
                            }
                        }
                    }
                }
                else if isFollowed == false{
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    followViewModel.followOnUser(userId: follow.followedUser.id) { status in
                        if status == true{
                            withAnimation(.easeInOut){
                                isFollowed = true
                            }
                        }
                    }
                }
            }) {
                Text(isFollowed == true ? "Вы подписаны" : "Подписаться")
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                    .foregroundColor(isFollowed == true ? .black : .white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 9)
                    .background(isFollowed == true ? Color(hex: "#efefef") : Color(hex: "#5B86E5"))
                    .cornerRadius(6)
                    .opacity(isFollowed == nil ? 0 : 1)
                    .overlay{
                        if isFollowed == nil{
                            ProgressView()
                        }
                    }
            }
            
            Button(action: {
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
                followViewModel.deleteFollower(userId: follow.followedUser.id) { status in
                    if status == true{
                        withAnimation(.easeInOut){
                            followViewModel.followers.removeAll(where: {$0.followedUser.id == follow.followedUser.id})
                        }
                    }
                }
            }){
                Image(systemName: "xmark.circle")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            .frame(width: 23, height: 23)
            .padding(.leading, 20)
        }
        .padding(.top, 5)
        .padding(.bottom, 10)
        .padding(.horizontal)
        .onAppear {
            followViewModel.checkFollowOnFollower(userId: follow.followedUser.id) { isFollowed in
                if isFollowed == true {
                    withAnimation(.easeInOut){
                        self.isFollowed = true
                    }
                }
                else {
                    withAnimation(.easeInOut){
                        self.isFollowed = false
                    }
                }
            }
        }
    }
}

private struct FollowingItemView : View {
    @EnvironmentObject var followViewModel: FollowViewModel
    @State var isFollowed: Bool = true
    var follow: FollowersResponse.FollowerModel
    
    var body : some View {
        HStack(alignment: .center, spacing: 0) {
            if let avatar = follow.followOnUser.avatar{
                WebImage(url: URL(string: "\(API_URL)/uploads/\(avatar)")!)
                    .resizable()
                    .frame(width: 44, height: 44)
                    .cornerRadius(10)
                    .padding(.trailing, 16)
            } else {
                UIDefaultAvatar(width: 44, height: 44, cornerRadius: 10)
                    .padding(.trailing, 16)
            }

            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                Text(follow.followOnUser.login!)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                Text(follow.followOnUser.career ?? "")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#828796"))
                Spacer()
            }
            Spacer()
            Button(action: {
                if isFollowed {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    followViewModel.unFollowOnUser(userId: follow.followOnUser.id) { status in
                        if status == true{
                            withAnimation(.easeInOut){
                                isFollowed = false
                            }
                        }
                    }
                } else {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    followViewModel.followOnUser(userId: follow.followOnUser.id) { status in
                        if status == true{
                            withAnimation(.easeInOut){
                                isFollowed = true
                            }
                        }
                    }
                }
            }) {
                Text(isFollowed ? "Вы подписаны" : "Подписаться")
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                    .foregroundColor(isFollowed ? .black : .white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 9)
                    .background(isFollowed ? Color(hex: "#efefef") : Color(hex: "#5B86E5"))
                    .cornerRadius(6)
            }
        }
        .padding(.top, 5)
        .padding(.bottom, 10)
        .padding(.horizontal)
    }
    
}
