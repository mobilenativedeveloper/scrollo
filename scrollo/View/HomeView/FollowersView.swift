//
//  FollowersView.swift
//  scrollo
//
//  Created by Artem Strelnik on 16.09.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct FollowersView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var followersViewModel: FollowersViewModel = FollowersViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
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
                Text("Подписчики")
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
            Spacer()
            VStack {
                if followersViewModel.load {
                    ScrollView {
                        ForEach(0..<followersViewModel.followers.count, id: \.self) {index in
                            let follower = followersViewModel.followers[index]
                            FollowerItemView(follower: follower)
                        }
                    }
                }
                else{
                    ProgressView()
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear{
            followersViewModel.getFollowers()
        }
    }
}

private struct FollowerItemView : View {
    var follower: FollowersResponse.FollowerModel
    
    var body : some View {
        HStack(alignment: .center, spacing: 0) {
            if let avatar = follower.followOnUser.avatar{
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
                Text(follower.followOnUser.login!)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                Text(follower.followOnUser.career ?? "")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#828796"))
                Spacer()
            }
            Spacer()
            Button(action: {}) {
                Text("Подписаться")
                    .font(.system(size: 11))
                    .foregroundColor(.white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 9)
                    .background(Color(hex: "#5B86E5"))
                    .cornerRadius(6)
            }
        }
        .padding(.top, 5)
        .padding(.bottom, 10)
        .padding(.horizontal)
    }
}
