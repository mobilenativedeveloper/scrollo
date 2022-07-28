//
//  ShareUsersPost.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

struct ShareUsersPost: View {
    var body: some View {
        HStack(spacing: 0) {
            ZStack{
                Image("story1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 18, height: 18)
                    .background(Color(hex: "#F2F2F2"))
                    .clipShape(Circle())
                    .background(
                        Circle()
                            .fill(Color(hex: "#F2F2F2"))
                            .frame(width: 20, height: 20)
                    )
                Image("story4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 18, height: 18)
                    .background(Color(hex: "#F2F2F2"))
                    .clipShape(Circle())
                    .background(
                        Circle()
                            .fill(Color(hex: "#F2F2F2"))
                            .frame(width: 20, height: 20)
                    )
                    .offset(x: 10)
                Image("story3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 18, height: 18)
                    .background(Color(hex: "#F2F2F2"))
                    .clipShape(Circle())
                    .background(
                        Circle()
                            .fill(Color(hex: "#F2F2F2"))
                            .frame(width: 20, height: 20)
                    )
                    .offset(x: 20)
            }
            .padding(.trailing, 35)
            Text("Привет друзья, как вы? Хочу поделиться новостями...")
                .font(Font.custom(GothamBook, size: 11))
                .padding(.trailing, 3)
            Spacer(minLength: 0)
            Button(action: {}){
                Text("Далее")
                    .font(Font.custom(GothamBook, size: 10))
                    .foregroundColor(.black)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
            }
            .background(Color(hex: "#F0F0F0"))
            .cornerRadius(50)
        }
        .padding(.top, 20)
    }
}

struct ShareUsersPost_Previews: PreviewProvider {
    static var previews: some View {
        ShareUsersPost()
    }
}
