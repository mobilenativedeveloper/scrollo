//
//  FollowUserControll.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

struct FollowUserControll: View {
    @EnvironmentObject var profileController: ProfileViewModel
    @State var load: Bool = false
    @State var followOnHim: Bool = false
    let userId: String

    init (userId: String) {
        self.userId = userId
    }

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                if !self.load {
                    self.handleFollow()
                }
            }) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(hex: self.followOnHim ? "#36DCD8" : "#5B86E5"))
                    .frame(width: 151, height: 45, alignment: .center)
                    .overlay(
                        self.Loading(),
                        alignment: .center
                    )
            }
            Spacer(minLength: 10)
            Button(action: {}) {
                Capsule(style: .continuous)
                    .stroke(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1))
                    .frame(width: 151, height: 45, alignment: .center)
                    .overlay(
                        Text("Написать")
                            .foregroundColor(Color(hex: "#2E313C")),
                        alignment: .center
                    )
            }
            Spacer()
        }
        .padding(.top, 14)
        .onAppear(perform: {
            profileController.checkFollowOnUser(userId: userId, completion: {status in
                if let status = status {
                    if status {
                        self.followOnHim = true
                    } else {
                        self.followOnHim = false
                    }
                }
            })
        })
    }

    @ViewBuilder
    private func Loading() -> some View {
        if self.load {
            ProgressView()
        } else {
            Text(self.followOnHim ? "Вы Подписаны" : "Подписаться")
                .foregroundColor(Color.white)
        }
    }

    private func handleFollow() {
        self.load = true
        if self.followOnHim {
            profileController.unFollowOnUser(userId: userId, completion: {
                DispatchQueue.main.async {
                    self.followOnHim = false
                    self.load = false
                }
            })
        } else {
            profileController.followOnUser(userId: userId, completion: {
                DispatchQueue.main.async {
                    self.followOnHim = true
                    self.load = false
                }
            })
        }
    }
}

//struct FollowUserControll_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowUserControll()
//    }
//}
