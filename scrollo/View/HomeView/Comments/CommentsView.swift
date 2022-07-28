//
//  CommentsView.swift
//  scrollo
//
//  Created by Artem Strelnik on 02.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

//struct CommentsView: View {
//
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @StateObject var commentsViewModel : CommentsViewModel = CommentsViewModel()
//    @State var reply : Reply = Reply(postCommentId: nil, login: "", isShow: false)
//    let post : PostModel
//
//
//    init (post: PostModel) {
//        self.post = post
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//
//            //MARK: Header bar
//            HStack {
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }) {
//                    Image("circle.left.arrow")
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                        .aspectRatio(contentMode: .fill)
//                }
//                Spacer(minLength: 0)
//                VStack(spacing: 4) {
//                    Text("\(self.post.creator.login)")
//                        .font(.system(size: 12))
//                        .foregroundColor(Color(hex: "#828796"))
//                    Text("комментарии")
//                        .font(.system(size: 20))
//                        .fontWeight(.bold)
//                        .textCase(.uppercase)
//                        .foregroundColor(Color(hex: "#2E313C"))
//                }
//                Spacer(minLength: 0)
//                Image("rounded.squere.pencile")
//                    .resizable()
//                    .frame(width: 24, height: 24)
//                    .aspectRatio(contentMode: .fill)
//            }
//            .padding(.horizontal)
//            .padding(.bottom)
//
//            //MARK: List comments
//            if commentsViewModel.load {
//                ScrollView {
////
//                    ForEach(0..<commentsViewModel.comments.count, id: \.self) {index in
//                        UICommentView(comment: $commentsViewModel.comments[index], reply: self.$reply, message: $commentsViewModel.content)
//                            .padding(.bottom, 19)
//                            .padding(.horizontal)
//                            .environmentObject(commentsViewModel)
//                    }
//                }
//            } else {
//                Spacer(minLength: 0)
//                ProgressView()
//            }
//
//            Spacer(minLength: 0)
//
//            //MARK: Footer
//            VStack(spacing: 0) {
//
//                if self.reply.isShow {
//                    HStack(alignment: .top){
//                        Text("Ваш ответ \(self.reply.login)")
//                            .foregroundColor(Color(hex: "#a8a8a8"))
//                        Spacer(minLength: 0)
//                        Button(action: {
//                            self.reply = Reply(postCommentId: nil, login: "", isShow: false)
//                        }) {
//                            Image(systemName: "xmark")
//                                .foregroundColor(Color(hex: "#000000"))
//                        }
//                    }
//                    .padding(.all, 10)
//                    .background(Color(hex: "#efefef"))
//                }
//
//                VStack(spacing: 0) {
//                    EmojiListView(comment: self.$commentsViewModel.content)
//                        .padding(.vertical, 5)
//                        .padding(.bottom)
//                        .padding(.horizontal)
//                    HStack {
//                        TextField("Добавьте комментарий...", text: self.$commentsViewModel.content)
//                        Button(action: {
//                            if !self.commentsViewModel.content.isEmpty {
//                                if !self.reply.isShow { self.commentsViewModel.addComment(postId: self.post.id) }
//
//                                if self.reply.isShow {
//                                    guard let commentId = self.reply.postCommentId else {return}
//                                    self.commentsViewModel.addReply(postCommentId: commentId)
//
//                                    self.reply = Reply(postCommentId: nil, login: "", isShow: false)
//                                }
//                                UIApplication.shared.endEditing()
//                                self.commentsViewModel.content = ""
//                            }
//                        }) {
//                            Image("send.comment.button")
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                                .aspectRatio(contentMode: .fill)
//                                .opacity(self.commentsViewModel.content.isEmpty ? 0 : 1)
//                                .animation(.default)
//                        }
//                    }
//                    .frame(height: 45)
//                    .padding(.horizontal)
//                    .background(
//                        RoundedRectangle(cornerRadius: 10.0)
//                            .strokeBorder(Color(hex: "#EFEFF4"), style: StrokeStyle(lineWidth: 1.0))
//
//                    )
//                    .padding(.horizontal, 5)
//                }
//                .padding(.horizontal, 8)
//                .padding()
//            }
//            .padding(.bottom)
//            .background(Color.white)
//            .clipShape(CustomCorner(radius: 20, corners: [.topLeft, .topRight]))
//            .shadow(color: Color(hex: "#282828").opacity(0.03), radius: 10, x: 0, y: -14)
//        }
//        .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
//        .ignoresSafeArea(.container, edges: .bottom)
//        .onTapGesture {
//            UIApplication.shared.endEditing()
//        }
//        .ignoreDefaultHeaderBar
//        .onAppear {
//            commentsViewModel.getPostComments(postId: self.post.id)
//        }
//    }
//}


struct UICommentView : View {
    @EnvironmentObject var commentsViewModel: CommentsViewModel
    @Binding var comment : PostModel.CommentsModel
    @Binding var reply : Reply
    @Binding var message : String

    init (comment: Binding<PostModel.CommentsModel>, reply: Binding<Reply>, message: Binding<String>) {
        self._comment = comment
        self._reply = reply
        self._message = message
    }

    var body : some View {

        VStack(spacing: 0) {

            self.content(avatar: comment.user.avatar, login: comment.user.login, content: comment.comment, liked: comment.liked, likesCount: comment.likesCount, replyCount: comment.lastSubComments.count, postCommentId: comment.id, replyId: nil)
                .padding(.bottom, 19)

            ForEach(0..<comment.lastSubComments.count, id: \.self) {index in
                let replyComment = comment.lastSubComments[index]

                self.content(avatar: replyComment.user.avatar, login: replyComment.user.login, content: replyComment.content, liked: replyComment.liked, likesCount: replyComment.likesCount, replyCount: 0, postCommentId: comment.id, replyId: replyComment.id)
                    .padding(.leading, 48)
                    .padding(.bottom)
            }
        }
    }

    @ViewBuilder
    private func content(avatar: String?, login: String, content: String, liked: Bool?, likesCount: Int?, replyCount: Int, postCommentId: String, replyId: String?) -> some View {

        VStack(alignment: .leading, spacing: 0) {

            HStack(alignment: .top, spacing: 0) {
                if let avatar = avatar {
                    AnimatedImage(url: URL(string: "\(API_URL)/uploads/\(avatar)")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .padding(.trailing, 16)
                } else {
                    UIDefaultAvatar(width: 32, height: 32, cornerRadius: 10)
                        .padding(.trailing, 16)
                }
                Text(login).foregroundColor(.black).font(.custom(GothamBold, size: 14)) + Text("  ") + textWithHashtags(content, color: Color(hex: "#5B86E5")).font(.custom(GothamBook, size: 12)).foregroundColor(Color(hex: "#828282"))
                Spacer()
                Text("3ч")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "#828282"))

            }
            HStack(spacing: 0) {
                Button(action: {
                    guard let like = liked else {return}
                    if like {
                        if let replyId = replyId {
                            commentsViewModel.replyLikeRemove(postCommentId: postCommentId, postCommentReplyId: replyId)
                        } else {
                            commentsViewModel.likeRemoveComment(postCommentId: postCommentId)
                        }
                        
                    } else {
                        if let replyId = replyId {
                            commentsViewModel.replyLike(postCommentId: postCommentId, postCommentReplyId: replyId)
                        } else {
                            commentsViewModel.likeComment(postCommentId: postCommentId)
                        }
                    }
                }) {
                    HStack(spacing: 0) {
                        if let liked = liked {
                            if liked {
                                Image("heart_active")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                            } else {
                                Image("heart_comment_inactive")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                            }
                            if (likesCount ?? 0) > 0 {
                                Text("\(likesCount!)")
                                    .font(.custom(GothamBold, size: 10))
                                    .foregroundColor(liked ? Color(hex: "#FF0F82") : Color(hex: "#000000"))
                                    .padding(.leading, 4)
                            }
                        }
                        
                    }
                }
                .padding(.trailing, 8)
                Button(action: {
                    
                    reply = Reply(postCommentId: postCommentId, login: login, isShow: true)
                }) {
                    HStack(spacing: 0) {
                        Image(replyCount > 0 ? "comment_reply_active" : "comment_reply_inactive")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        if replyCount > 0 {
                            Text("\(replyCount)")
                                .font(.custom(GothamBold, size: 10))
                                .foregroundColor(.black)
                                .padding(.leading, 4)
                        }
                    }
                }
            }
            .padding(.top, 9)
            .padding(.leading, 48)
        }
    }
}


struct Reply {
    var postCommentId : String?
    var login : String
    var isShow : Bool
}
