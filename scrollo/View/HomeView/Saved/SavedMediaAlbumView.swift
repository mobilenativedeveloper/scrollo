//
//  SavedMediaAlbumView.swift
//  scrollo
//
//  Created by Artem Strelnik on 08.07.2022.
//

import SwiftUI

struct SavedMediaAlbumView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
   
    @State var selectedTab: String = "photo"
    let headerTitle: String
    let width = (UIScreen.main.bounds.width / 3) - 16
    
    init (headerTitle: String = "Идеи для портретов") {
        self.headerTitle = headerTitle
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("comments_back")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
                Spacer(minLength: 0)
                Text("сохранённое")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(Color(hex: "#1F2128"))
                Spacer(minLength: 0)
                Button(action: {
                    
                }) {
                    Color.clear
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.top)
            .padding(.horizontal)
            .padding(.bottom)
            HStack(spacing: 0) {
                Button(action: {
                    self.selectedTab = "photo"
                }) {
                    Rectangle()
                        .stroke(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1))
                        .overlay(
                            self.getTabImage(active: "profile_media_post_tab_active", inactive: "profile_media_post_tab_inactive", selection: self.selectedTab == "photo")
                        )
                }
                Button(action: {
                    self.selectedTab = "video"
                }) {
                    Rectangle()
                        .stroke(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1))
                        .overlay(
                            self.getTabImage(active: "camera_active", inactive: "camera_inactive", selection: self.selectedTab == "video")
                        )
                }
            }
            .frame(height: 55)
            ScrollView {
                VStack(spacing: 0) {
                    if self.selectedTab == "photo" {
                        HStack(alignment: .top, spacing: 8) {
                            VStack(spacing: 8) {
                                Image("story1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: 121)
                                    .clipped()
                                    .cornerRadius(6)
                                Image("story2")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: 121)
                                    .clipped()
                                    .cornerRadius(6)
                                Image("story3")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: 189)
                                    .clipped()
                                    .cornerRadius(6)
                            }
                            VStack(spacing: 8) {
                                Image("story4")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: 189)
                                    .clipped()
                                    .cornerRadius(6)
                                Image("story1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: 121)
                                    .clipped()
                                    .cornerRadius(6)
                                Image("story2")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: 189)
                                    .clipped()
                                    .cornerRadius(6)
                            }
                            VStack(spacing: 8) {
                                Image("story3")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: 121)
                                    .clipped()
                                    .cornerRadius(6)
                                Image("story4")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: 189)
                                    .clipped()
                                    .cornerRadius(6)
                                Image("story1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: 121)
                                    .clipped()
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
                .padding(.horizontal, 26)
            }
        }

    }
    
    @ViewBuilder
    private func getTabImage(active: String, inactive: String, selection: Bool) -> some View {
        let image: String = selection ? active : inactive
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 22, height: 22)
    }
}

struct SavedMediaAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        SavedMediaAlbumView()
    }
}
