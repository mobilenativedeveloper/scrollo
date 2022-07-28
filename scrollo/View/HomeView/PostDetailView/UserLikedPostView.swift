//
//  UserLikedPostView.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

struct UserLikedPostView: View {
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
                Image("story2")
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
            Text("нравится Mike_Bulkin и еще 524 людям")
                .font(Font.custom(GothamBold, size: 11))
                .padding(.trailing, 3)
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .padding(.top, 5)
    }
}

struct UserLikedPostView_Previews: PreviewProvider {
    static var previews: some View {
        UserLikedPostView()
    }
}
