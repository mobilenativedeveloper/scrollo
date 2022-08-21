//
//  PostHeaderView.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostHeaderView: View {
    @State var isPresentProfile: Bool = false
    @State var isPresentSheet: Bool = false
    var userId: String
    var avatar: String?
    var login: String
    var place: PostModel.Place?
    var postId: String
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                isPresentProfile.toggle()
            }) {
                if let avatar = avatar {
                    WebImage(url: URL(string: "\(API_URL)/uploads/\(avatar)"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                        .clipped()
                        .cornerRadius(10)
                        .padding(.trailing, 7)
                } else {
                    UIDefaultAvatar(width: 35, height: 35, cornerRadius: 10)
                        .padding(.trailing, 7)
                }
            }
//            .background(NavigationLink(destination: ProfileView(userId: userId).ignoreDefaultHeaderBar, isActive: $isPresentProfile, label: {
//                EmptyView()
//            }).buttonStyle(PlainButtonStyle()).frame(height: 0).opacity(0).hidden())
            .buttonStyle(FlatLinkStyle())
            Button(action: {
                isPresentProfile.toggle()
            }) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(login)
                        .font(.system(size: 14))
                        .fontWeight(Font.Weight.bold)
                        .foregroundColor(Color(hex: "#333333"))
                        .offset(y: -5)
                    if let place = place {
                        Text("\(place.name)")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#909090"))
                    } else {
                        Text("")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#909090"))
                    }
                }
            }
//            .background(NavigationLink(destination: ProfileView(userId: userId).ignoreDefaultHeaderBar, isActive: $isPresentProfile, label: {
//                EmptyView()
//            }).buttonStyle(PlainButtonStyle()).frame(height: 0).opacity(0).hidden())
            .buttonStyle(FlatLinkStyle())
            Spacer()
            Button(action: {
                NotificationCenter.default.post(name: NSNotification.Name(openPostActionsSheet), object: nil, userInfo: [
                    "postId": postId
                ])
            }) {
                Image("menu")
            }
            .frame(width: 50, height: 50)
            .cornerRadius(50)
            .offset(x: 14)
        }
    }
}
