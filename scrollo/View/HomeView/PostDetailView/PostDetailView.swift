//
//  PostDetailView.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

struct PostDetailView: View {
    @StateObject var commentsViewModel: CommentsViewModel = CommentsViewModel()
    @State var reply : Reply = Reply(postCommentId: nil, login: "", isShow: false)
    @Binding var post: PostModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    PostHeaderView(userId: post.creator.id, avatar: post.creator.avatar, login: post.creator.login, place: post.place)
                        .padding(.horizontal)
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                        .background(Color.white)
                    if post.type == "STANDART" {
                        if let files = post.files {
                            PostMediaCarouselView(images: files)
                                .padding(.horizontal)
                            PostFooterView(post: $post)
                                .padding(.top, 17)
                                .padding(.horizontal)
                        }
                    }
                    Text(post.content)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .padding(.bottom)
                    if post.type == "TEXT" {
                        PostFooterView(post: $post)
                            .padding(.top, 17)
                            .padding(.horizontal)
                    }
                    UserLikedPostView()
                }
                .background(Color.white)
                .clipShape(CustomCorner(radius: 17, corners: [.bottomRight, .bottomLeft]))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 20)
                .padding(.bottom, 25)
                if commentsViewModel.load {
                    ForEach(0..<commentsViewModel.comments.count, id: \.self) {index in
                        UICommentView(comment: $commentsViewModel.comments[index], reply: self.$reply, message: $commentsViewModel.content)
                            .padding(.bottom, 19)
                            .padding(.horizontal)
                            .environmentObject(commentsViewModel)
                    }
                } else {
                    ProgressView()
                }
            }
            Spacer(minLength: 0)
            PostDetailFooterView(post: $post, reply: self.$reply)
                .environmentObject(commentsViewModel)
        }
        .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
        .ignoresSafeArea(.container, edges: [.bottom, .top])
        .onTapGesture(perform: {
            UIApplication.shared.endEditing()
        })
        .onAppear {
            commentsViewModel.getPostComments(postId: post.id)
        }
    }
}

//struct PostDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostDetailView()
//    }
//}
