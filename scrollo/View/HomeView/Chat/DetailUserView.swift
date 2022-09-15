//
//  DetailUserView.swift
//  scrollo
//
//  Created by Artem Strelnik on 15.09.2022.
//

import SwiftUI

struct DetailUserView: View {
    var body: some View {
        VStack(spacing: 0){
            Image("testUserPhoto")
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .padding(.bottom, 6)
            Text("Name Lastname")
                .font(.system(size: 14))
                .fontWeight(.bold)
                .padding(.bottom, 3)
            Text("login • Scrollo")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#838383"))
                .padding(.bottom, 1)
            Text("Подписчики: 135 • Публикации: 0")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#838383"))
                .padding(.bottom, 8)
            NavigationLink(destination: Text("Profile").ignoreDefaultHeaderBar){
                Text("Посмотреть профиль")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 13)
                    .background(Color(hex: "#efefef").cornerRadius(8))
            }
        }
    }
}
