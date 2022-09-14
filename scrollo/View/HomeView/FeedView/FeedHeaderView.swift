//
//  FeedHeaderView.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI

struct FeedHeaderView: View {
    var body: some View {
        HStack {
            Image("logo_large")
                .resizable()
                .frame(width: 95, height: 21)
            Spacer()
            NavigationLink(destination: ChatListView().ignoreDefaultHeaderBar) {
                Image("messanger")
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 4)
            }
        }
        .padding(.horizontal)
        .background(Color(hex: "#F9F9F9"))
    }
}

struct FeedHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        FeedHeaderView()
    }
}
