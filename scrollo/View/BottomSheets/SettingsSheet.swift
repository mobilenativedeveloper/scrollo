//
//  SettingsSheet.swift
//  scrollo
//
//  Created by Artem Strelnik on 20.08.2022.
//

import SwiftUI

struct SettingsSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isPresentSettingsView: Bool
    @Binding var isPresentYourActivityView: Bool
    @Binding var isPresentSavedView: Bool
    @Binding var isPresentInterestingPeopleView: Bool
    @Binding var isPresentEditProfileView: Bool
    
    let time: CGFloat = 0.2
    
    var body: some View {
        VStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    isPresentYourActivityView.toggle()
                }
            }) {
                HStack {
                    Image("your_activity")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("Ваша активность")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2E313C"))
                    Spacer(minLength: 0)
                }
                .padding()
            }
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    isPresentSavedView.toggle()
                }
            }) {
                HStack {
                    Image("saves")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("Сохраненное")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2E313C"))
                    Spacer(minLength: 0)
                }
                .padding()
            }
            Button(action: {}) {
                HStack {
                    Image("favorite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("Близкие друзья")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2E313C"))
                    Spacer(minLength: 0)
                }
                .padding()
            }
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    isPresentInterestingPeopleView.toggle()
                }
            }) {
                HStack {
                    Image("add_friend")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("Интересные люди")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2E313C"))
                    Spacer(minLength: 0)
                }
                .padding()
            }
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    isPresentEditProfileView.toggle()
                }
            }) {
                HStack {
                    Image("edit_profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    Text("Редактировать профиль")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2E313C"))
                    Spacer(minLength: 0)
                }
                .padding()
            }
            Spacer(minLength: 0)
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    isPresentSettingsView.toggle()
                }
            }) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color(hex: "#F2F2F2"))
                        .frame(height: 1)
                    HStack {
                        Image("settings")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        Text("Настройки")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#2E313C"))
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 17)
                }
            }
        }
        .background(Color.white)
        .frame(width: SCREEN_WIDTH - 40)
        .cornerRadius(25)
    }
}
