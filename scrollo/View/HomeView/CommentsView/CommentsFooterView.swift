//
//  CommentsFooterView.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

struct CommentsFooterView: View {
    @EnvironmentObject var commentsViewModel: CommentsViewModel
    @Binding var reply: Reply
    @Binding var post: PostModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            if reply.isShow {
                HStack(alignment: .top){
                    Text("Ваш ответ \(reply.login)")
                        .foregroundColor(Color(hex: "#a8a8a8"))
                    Spacer(minLength: 0)
                    Button(action: {
                        reply = Reply(postCommentId: nil, login: "", isShow: false)
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(hex: "#000000"))
                    }
                }
                .padding(.all, 10)
                .background(Color(hex: "#efefef"))
            }
            
            VStack(spacing: 0) {
                EmojiListView(comment: $commentsViewModel.content)
                    .padding(.vertical, 5)
                    .padding(.bottom)
                    .padding(.horizontal)
                HStack {
                    TextField("Добавьте комментарий...", text: $commentsViewModel.content)
                    Button(action: {
                        if !commentsViewModel.content.isEmpty {
                            if !reply.isShow { commentsViewModel.addComment(postId: post.id) }
                            
                            if reply.isShow {
                                guard let commentId = reply.postCommentId else {return}
                                commentsViewModel.addReply(postCommentId: commentId)
                                
                                reply = Reply(postCommentId: nil, login: "", isShow: false)
                            }
                            UIApplication.shared.endEditing()
                            commentsViewModel.content = ""
                        }
                    }) {
                        Image("send.comment.button")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .aspectRatio(contentMode: .fit)
                            .opacity(commentsViewModel.content.isEmpty ? 0 : 1)
                    }
                }
                .frame(height: 45)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 10.0)
                        .strokeBorder(Color(hex: "#EFEFF4"), style: StrokeStyle(lineWidth: 1.0))
                        
                )
                .padding(.horizontal, 5)
            }
            .padding(.horizontal, 8)
            .padding()
        }
        .padding(.bottom)
        .background(Color.white)
        .clipShape(CustomCorner(radius: 20, corners: [.topLeft, .topRight]))
        .shadow(color: Color(hex: "#282828").opacity(0.03), radius: 10, x: 0, y: -14)
    }
}

//struct CommentsFooterView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentsFooterView()
//    }
//}
