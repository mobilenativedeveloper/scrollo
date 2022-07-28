//
//  PostFooterView.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI
import UISheetPresentationControllerCustomDetent

struct PostFooterView: View {
    
    @Binding var post: PostModel
    @StateObject var likePostController: LikePostViewModel = LikePostViewModel()
    @StateObject var dislikeController: DislikePostViewModel = DislikePostViewModel()
    @StateObject var savePostController: SavePostViewModel = SavePostViewModel()
    @State var commentsViewPresent: Bool = false
    
    var body: some View {
        HStack(spacing: 5) {
            
            Button(action: {
                if !post.disliked {
                    if post.liked {
                        likePostController.removeLike(postId: post.id, completed: {
                            post.liked = false
                            post.likesCount = post.likesCount - 1
                        })
                    } else {
                        likePostController.addLike(postId: post.id, completed: {
                            post.liked = true
                            post.likesCount = post.likesCount + 1
                        })
                    }
                }
            }) {
                HStack(spacing: 0) {
                    Image(post.liked ? "heart_active" : "heart_inactive")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 21, height: 21)
                        .padding(.trailing, 6)
                    if let count = post.likesCount {
                        Text("\(count)")
                            .font(Font.custom(GothamBold, size: 12))
                            .foregroundColor(Color.black)
                    }
                }
            }
            .frame(height: 20)
            .padding(.horizontal, 17)
            .padding(.vertical, 6)
            .background(post.liked ? Color(hex: "#F0F0F0") : Color.clear)
            .cornerRadius(30)
            .buttonStyle(PlainButtonStyle())
            Button(action: {
                if !post.liked {
                    if post.disliked {
                        dislikeController.removeDislike(postId: post.id) {
                            post.disliked = false
                            post.dislikeCount = post.dislikeCount - 1
                        }
                    } else {
                        dislikeController.addDislike(postId: post.id) {
                            post.disliked = true
                            post.dislikeCount = post.dislikeCount + 1
                        }
                    }
                }
            }) {
                HStack(spacing: 0) {
                    Image(post.disliked ? "dislike_active" : "dislike_inactive")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 21, height: 21)
                        .padding(.trailing, 6)
                    if let count = post.dislikeCount {
                        Text("\(count)")
                            .font(Font.custom(GothamBold, size: 12))
                            .foregroundColor(Color.black)
                    }
                }
            }
            .frame(height: 20)
            .padding(.horizontal, 17)
            .padding(.vertical, 6)
            .background(post.disliked ? Color(hex: "#F0F0F0") : Color.clear)
            .cornerRadius(30)
            .buttonStyle(PlainButtonStyle())
            Button(action: {
                self.commentsViewPresent.toggle()
            }) {
                HStack(spacing: 0) {
                    Image("comments")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 21, height: 21)
                        .padding(.trailing, 6)
                    Text("\(post.commentsCount)")
                        .font(Font.custom(GothamBold, size: 12))
                        .foregroundColor(Color.black)
                }
                .frame(width: 61, height: 20)
            }
            .background(NavigationLink(destination: CommentsView(post: $post).ignoreDefaultHeaderBar, isActive: self.$commentsViewPresent, label: {
                EmptyView()
            }).buttonStyle(PlainButtonStyle()).frame(height: 0).opacity(0).hidden())
            .buttonStyle(PlainButtonStyle())
            Button(action: {
                print("share")
            }) {
                Image("share")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 21, height: 21)
            }
            .frame(width: 61, height: 20)
            .buttonStyle(PlainButtonStyle())
            Spacer(minLength: 0)
            Button(action: {
                if post.type == "STANDART" {
                    if post.inSaved {
                        savePostController.removeSaveMediaPost(postId: post.id, completed: {
                            post.inSaved = false
                        })
                    } else {
                        savePostController.isPresentListAbums.toggle()
                    }
                }
            }) {
                if post.inSaved {
                    Image("bookmark_active")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 21, height: 21)
                } else {
                    Image("bookmark_inactive")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 21, height: 21)
                }

            }
            .buttonStyle(PlainButtonStyle())
        }
        .sheetWithDetents(isPresented: $savePostController.isPresentListAbums, detents: [.custom(240)]) {
            
        } content: {
            SavedPostSheetView(post: $post)
                .environmentObject(savePostController)
        }
    }
}

//struct PostFooterView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostFooterView()
//    }
//}


