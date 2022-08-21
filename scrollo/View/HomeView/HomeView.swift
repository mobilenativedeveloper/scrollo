//
//  HomeView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI




struct ShareBottomSheet : View {
    @State var searchText: String = ""
    var body : some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("поделиться")
                    .textCase(.uppercase)
                    .font(.custom(GothamBold, size: 23))
                    .foregroundColor(Color(hex: "2E313C"))
                Spacer(minLength: 0)
                Button(action: {}) {
                    Image("share.square")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.bottom, 25)
            
            HStack(spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(hex: "#444A5E"))
                    .padding(.trailing, 8)
                TextField("Найти", text: self.$searchText)
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .strokeBorder(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1.0))
                    
            )
            .padding(.bottom, 38)
            
            ForEach(0..<2, id: \.self) {_ in
                HStack(spacing: 16) {
                    ForEach(0..<4, id:\.self) {_ in
                        Button(action: {}) {
                            VStack(spacing: 0) {
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 54, height: 54)
                                    .cornerRadius(10)
                                    .padding(.bottom, 12)
                                Text("Lana Smith")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#444A5E"))
                            }
                        }
                    }
                }
                .padding(.bottom, 17)
            }
            
            Button(action: {}) {
                Text("Отправить")
                    .font(.custom(GothamMedium, size: 14))
                    .foregroundColor(.white)
            }
            .frame(width: 130, height: 56)
            .background(
                LinearGradient(colors: [Color(hex: "#5B86E5"), Color(hex: "#36DCD8")], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(40)
        }
        .padding(.horizontal, 32)
    }
}

