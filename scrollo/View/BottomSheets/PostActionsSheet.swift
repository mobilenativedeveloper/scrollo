//
//  PostActionsSheet.swift
//  scrollo
//
//  Created by Artem Strelnik on 20.08.2022.
//

import SwiftUI

struct PostActionsSheet: View {
    @EnvironmentObject var bottomSheets: BottomSheetViewModel
    @ObservedObject var removePostViewModel: RemovePostViewModel = RemovePostViewModel()
    @State var removePost: Bool = false
    let postId: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                CustomButtonPostSheet(title: "поделиться", image: "share_bottom_sheet")
                CustomButtonPostSheet(title: "ссылка", image: "link_bottom_sheet")
                CustomButtonPostSheet(title: "пожаловаться", image: "report_bottom_sheet")
            }
            .padding(.bottom)
            VStack {
                Spacer(minLength: 0)
                Button(action: {}) {
                    VStack(spacing: 0) {
                        Text("Добавить в избранное")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .padding(.bottom, 15)
                        Rectangle()
                            .fill(Color(hex: "#D8D2E5").opacity(0.25))
                            .frame(width: UIScreen.main.bounds.width - 42, height: 1)
                    }
                }
                .padding(.vertical, 13)
                Button(action: {}) {
                    VStack(spacing: 0) {
                        Text("Скрыть")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .padding(.bottom, 15)
                        Rectangle()
                            .fill(Color(hex: "#D8D2E5").opacity(0.25))
                            .frame(width: UIScreen.main.bounds.width - 42, height: 1)
                    }
                }
                .padding(.bottom, 13)
                Button(action: {}) {
                    VStack(spacing: 0) {
                        Text("Отменить подписку")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .padding(.bottom, 15)
                        Rectangle()
                            .fill(Color(hex: "#D8D2E5").opacity(0.25))
                            .frame(width: UIScreen.main.bounds.width - 42, height: 1)
                    }
                }
                .padding(.bottom, 13)
                Button(action: {
                    self.removePost = true
                }) {
                    VStack(spacing: 0) {
                        Text("Удалить")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#EB5757"))
                            .padding(.bottom, 15)
                        Rectangle()
                            .fill(Color(hex: "#D8D2E5").opacity(0.25))
                            .frame(width: UIScreen.main.bounds.width - 42, height: 1)
                    }
                }
                Spacer(minLength: 0)
            }
            .frame(width: (UIScreen.main.bounds.width - 42))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#FAFAFA"))
                    .modifier(RoundedEdge(width: 1, color: Color(hex: "#DFDFDF"), cornerRadius: 10))
            )
        }
        .padding(.bottom, 24)
        .padding(.top, 43)
        .background(Color.white)
        .alert(isPresented: self.$removePost, content: {
            Alert(
                title: Text("Удалить публикацию ?"),
                primaryButton: Alert.Button.destructive(Text("Удалить"), action: {
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        removePostViewModel.removePost(postId: postId) {
                            NotificationCenter.default.post(name: NSNotification.Name(postRemoveFromFeed), object: nil, userInfo: [
                                "postId": postId
                            ])
                            
                        }
                    }
                }),
                secondaryButton: .default(
                    Text("Отмена")
                )
            )
        })
    }
    
    @ViewBuilder
    func CustomButtonPostSheet(title: String, image: String) -> some View {
        Button(action: {}) {
            VStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .padding(.bottom, 1)
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.black)
            }
        }
        .frame(width: (UIScreen.main.bounds.width - 42) / 3.2, height: ((UIScreen.main.bounds.width - 78) / 3) / 1.5, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#FAFAFA"))
                .modifier(RoundedEdge(width: 1, color: Color(hex: "#DFDFDF"), cornerRadius: 10))
        )
    }
}
