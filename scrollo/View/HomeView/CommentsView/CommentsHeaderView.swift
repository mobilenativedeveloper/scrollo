//
//  CommentsHeaderView.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

struct CommentsHeaderView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var login: String
    
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("circle.left.arrow")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .aspectRatio(contentMode: .fill)
            }
            Spacer(minLength: 0)
            VStack(spacing: 4) {
                Text("\(login)")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#828796"))
                Text("комментарии")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(Color(hex: "#2E313C"))
            }
            Spacer(minLength: 0)
            Image("rounded.squere.pencile")
                .resizable()
                .frame(width: 24, height: 24)
                .aspectRatio(contentMode: .fill)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

//struct CommentsHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentsHeaderView()
//    }
//}
