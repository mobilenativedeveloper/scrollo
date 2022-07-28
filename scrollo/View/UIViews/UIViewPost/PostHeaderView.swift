//
//  PostHeaderView.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostHeaderView: View {
    @State var isPresentSheet: Bool = false
    var avatar: String?
    var login: String
    var place: PostModel.Place?
    
    var body: some View {
        HStack(spacing: 0) {
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
            Spacer()
            Button(action: {
                isPresentSheet.toggle()
            }) {
                VStack {
                    Image("menu")
                }
                .frame(width: 50, height: 50)
            }
            .frame(width: 50, height: 50)
            .cornerRadius(50)
            .offset(x: 14)
            .buttonStyle(FlatLinkStyle())
        }
        .sheetWithDetents(isPresented: $isPresentSheet, detents: [.medium()]) {
            
        } content: {
            PostBottomSheetContent()
        }
    }
}

//struct PostHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostHeaderView()
//    }
//}
