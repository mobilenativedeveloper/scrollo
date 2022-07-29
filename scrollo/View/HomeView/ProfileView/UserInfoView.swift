//
//  UserInfo.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

struct UserInfoView: View {
    var login: String
    var career: String?
    var personal: UserModel.Personal?
    
    var body: some View {
        VStack{
            Text("\(login)")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#1F2128"))
            if let career = career {
                if career != "" {
                    Text(career)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#5B86E5"))
                        .padding(.top, 1)
                }
            }
            if let bio = personal?.bio {
                if bio != "" {
                    Text(bio)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#828796"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                        .padding(.top, 2)
                }
            }
            if let website = personal?.website {
                if website != "" {
                    Text(website)
                        .font(.system(size: 12))
                        .foregroundColor(Color.blue)
                        .padding(.top, 1)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.top, 10)
    }
}

//struct UserInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        UserInfo()
//    }
//}
