//
//  FollowInfoView.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

struct FollowInfoView: View {
    var followersCount: Int
    var followingCount: Int
    var body: some View {
        HStack {
            VStack {
                Text("\(followersCount)")
                    .font(.system(size: 21))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#1F2128"))
                Text("подписчики")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#828796"))
            }
            Spacer()
            VStack {
                Text("\(followingCount)")
                    .font(.system(size: 21))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#1F2128"))
                Text("подписки")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#828796"))
            }
        }
        .padding(.top, 28)
        .padding(.horizontal, 33)
    }
}

//struct FollowInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowInfoView()
//    }
//}
