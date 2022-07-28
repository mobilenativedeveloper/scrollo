//
//  CommentsDetailView.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var commentsViewModel : CommentsViewModel = CommentsViewModel()
    @State var reply : Reply = Reply(postCommentId: nil, login: "", isShow: false)
    @Binding var post : PostModel
    
    var body: some View {
        VStack(spacing: 0) {
            CommentsHeaderView(login: post.creator.login)
            //MARK: List comments
            if commentsViewModel.load {
                ScrollView {
                    ForEach(0..<commentsViewModel.comments.count, id: \.self) {index in
                        UICommentView(comment: $commentsViewModel.comments[index], reply: self.$reply, message: $commentsViewModel.content)
                            .padding(.bottom, 19)
                            .padding(.horizontal)
                            .environmentObject(commentsViewModel)
                    }
                }
            } else {
                Spacer(minLength: 0)
                ProgressView()
            }
            Spacer(minLength: 0)
            CommentsFooterView(reply: self.$reply, post: $post)
                .environmentObject(commentsViewModel)
        }
        .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
        .ignoresSafeArea(.container, edges: .bottom)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            commentsViewModel.getPostComments(postId: self.post.id)
        }
    }
}

//struct CommentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentsView()
//    }
//}
