//
//  UIViewTextPost.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI

struct UIViewTextPost: View {
    @Binding var post: PostModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PostHeaderView(userId: post.creator.id, avatar: post.creator.avatar, login: post.creator.login, place: post.place)
                .padding(.bottom, 13)
            
            TruncateTextView(text: post.content)
            
            PostFooterView(post: $post)
                .padding(.top, 17)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 14)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 9, x: 0, y: 0)
        .padding(.vertical, 13.5)
        .padding(.horizontal)
    }
}

//struct UIViewTextPost_Previews: PreviewProvider {
//    static var previews: some View {
//        UIViewTextPost()
//    }
//}
