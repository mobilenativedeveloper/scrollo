//
//  PostDetailView.swift
//  scrollo
//
//  Created by Artem Strelnik on 11.07.2022.
//

import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject var bottomSheetViewModel: BottomSheetViewModel
    @Binding var post: PostModel
    @StateObject var commentsViewModel: CommentsViewModel = CommentsViewModel()
    @State var reply : Reply = Reply(postCommentId: nil, login: "", isShow: false)
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    
                    PostHeader(post: post, isDetail: true)
                        .padding(.horizontal)
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                        .background(Color.white)
                    if post.type == "STANDART" {
                        if let files = post.files {
                            PostMediaCarousel(images: files)
                                .padding(.horizontal)
                            PostFooter(post: $post)
                                .padding(.top, 17)
                                .padding(.horizontal)
                                .environmentObject(bottomSheetViewModel)
                        }
                    }
                    Text(post.content)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .padding(.bottom)
                    if post.type == "TEXT" {
                        PostFooter(post: $post, isDetail: true)
                            .padding(.horizontal)
                            .padding(.top, 17)
                            
                            .environmentObject(bottomSheetViewModel)
                    }
                    HStack(spacing: 0) {
                        ZStack{
                            Image("story1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 18, height: 18)
                                .background(Color(hex: "#F2F2F2"))
                                .clipShape(Circle())
                                .background(
                                    Circle()
                                        .fill(Color(hex: "#F2F2F2"))
                                        .frame(width: 20, height: 20)
                                )
                            Image("story2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 18, height: 18)
                                .background(Color(hex: "#F2F2F2"))
                                .clipShape(Circle())
                                .background(
                                    Circle()
                                        .fill(Color(hex: "#F2F2F2"))
                                        .frame(width: 20, height: 20)
                                )
                                .offset(x: 10)
                            Image("story3")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 18, height: 18)
                                .background(Color(hex: "#F2F2F2"))
                                .clipShape(Circle())
                                .background(
                                    Circle()
                                        .fill(Color(hex: "#F2F2F2"))
                                        .frame(width: 20, height: 20)
                                )
                                .offset(x: 20)
                        }
                        .padding(.trailing, 35)
                        Text("нравится Mike_Bulkin и еще 524 людям")
                            .font(Font.custom(GothamBold, size: 11))
                            .padding(.trailing, 3)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .padding(.top, 5)
                }
                .background(Color.white)
                .clipShape(CustomCorner(radius: 17, corners: [.bottomRight, .bottomLeft]))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 20)
                .padding(.bottom, 25)
                //MARK: Comments
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
            
            //MARK: Footer
            VStack(spacing: 0) {
                
                if self.reply.isShow {
                    HStack(alignment: .top){
                        Text("Ваш ответ \(self.reply.login)")
                            .foregroundColor(Color(hex: "#a8a8a8"))
                        Spacer(minLength: 0)
                        Button(action: {
                            self.reply = Reply(postCommentId: nil, login: "", isShow: false)
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color(hex: "#000000"))
                        }
                    }
                    .padding(.all, 10)
                    .background(Color(hex: "#efefef"))
                }
                
                VStack(spacing: 0) {
                    EmojiListView(comment: self.$commentsViewModel.content)
                        .padding(.vertical, 5)
                        .padding(.bottom)
                        .padding(.horizontal)
                    HStack {
                        TextField("Добавьте комментарий...", text: self.$commentsViewModel.content)
                        Button(action: {
                            if !self.commentsViewModel.content.isEmpty {
                                if !self.reply.isShow { self.commentsViewModel.addComment(postId: self.post.id) }
                                
                                if self.reply.isShow {
                                    guard let commentId = self.reply.postCommentId else {return}
                                    self.commentsViewModel.addReply(postCommentId: commentId)
                                    
                                    self.reply = Reply(postCommentId: nil, login: "", isShow: false)
                                }
                                UIApplication.shared.endEditing()
                                self.commentsViewModel.content = ""
                            }
                        }) {
                            Image("send.comment.button")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .aspectRatio(contentMode: .fill)
                                .opacity(self.commentsViewModel.content.isEmpty ? 0 : 1)
                                .animation(.default)
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
        .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
        .ignoresSafeArea(.container, edges: [.bottom, .top])
        .onTapGesture(perform: {
            UIApplication.shared.endEditing()
        })
        .bottomSheet(isPresented: $bottomSheetViewModel.postDetailBottomSheet, height: UIScreen.main.bounds.height / 2, topBarCornerRadius: 16, corners: false) {
            PostBottomSheetContent().environmentObject(bottomSheetViewModel)
        }
        .bottomSheet(isPresented: self.$bottomSheetViewModel.isShareBottomSheet, height: UIScreen.main.bounds.height / 2, topBarCornerRadius: 16, showTopIndicator: true, corners: false) {
            ShareBottomSheet()
        }
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
