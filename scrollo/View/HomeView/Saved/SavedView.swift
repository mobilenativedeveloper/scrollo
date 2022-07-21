//
//  SavedView.swift
//  scrollo
//
//  Created by Artem Strelnik on 08.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct SavedView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selection: String = "Медиа"
    private let tabs: [String] = ["Медиа", "Посты"]
    let savedItemSize: CGFloat = (UIScreen.main.bounds.width / 2) - 26 - 9
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("circle_close")
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
                    Image("blue_circle_outline_plus")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.top)
            .padding(.horizontal)
            self.tabsHeader()
            VStack {
                TabView(selection: self.$selection) {
                    VStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 0) {
                                ForEach(0..<4, id: \.self){_ in
                                    HStack(spacing: 0) {
                                        SavedItem()
                                        Spacer(minLength: 0)
                                        SavedItem()
                                    }
                                }
                            }
                            .padding(.horizontal, 26)
                            .padding(.top, 10)
                        }
                    }
                    .tag("Медиа")
                    VStack {
                        Text("Посты")
                    }
                    .tag("Посты")
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: Alignment(horizontal: .leading, vertical: .top))
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    @ViewBuilder
    private func tabsHeader() -> some View {
        HStack(spacing: 0) {
            ForEach(0..<self.tabs.count, id: \.self) {index in
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    Button(action: {
                        self.selection = self.tabs[index]
                    }) {
                        Text(self.tabs[index])
                            .font(.custom(self.selection == self.tabs[index] ? GothamBold : GothamBook, size: 13))
                            .textCase(.uppercase)
                            .foregroundColor(Color(hex: self.selection == self.tabs[index] ? "#5B86E5" :  "#333333"))
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / CGFloat(self.tabs.count) - 32))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "#5B86E5").opacity(self.selection == self.tabs[index] ? 1 : 0))
                        .frame(width: (UIScreen.main.bounds.width / CGFloat(self.tabs.count) - 32), height: 3)
                        .animation(.spring())
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func SavedItem() -> some View {
        NavigationLink(destination: SavedMediaAlbumView().ignoreDefaultHeaderBar) {
            VStack {
                VStack(spacing: 1) {
                    HStack(spacing: 1) {
                        Image("story1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: savedItemSize / 2, height: savedItemSize / 2)
                            .cornerRadius(6)
                        Image("story2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: savedItemSize / 2, height: savedItemSize / 2)
                            .cornerRadius(6)
                    }
                    HStack(spacing: 1) {
                        Image("story3")
                            .resizable()
                            .scaledToFill()
                            .frame(width: savedItemSize / 2, height: savedItemSize / 2)
                            .cornerRadius(6)
                        Image("story4")
                            .resizable()
                            .scaledToFill()
                            .frame(width: savedItemSize / 2, height: savedItemSize / 2)
                            .cornerRadius(6)
                    }
                }
                .frame(width: savedItemSize, height: savedItemSize)
                .clipped()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 1)
                        )
                        .frame(width: savedItemSize + 12, height: savedItemSize + 12)
                        .foregroundColor(Color(hex: "#909090"))
                )
                .padding(.bottom, 10)
                Text("идеи потретов")
                    .font(.custom(GothamBold, size: 14))
                    .foregroundColor(Color(hex: "#2E313C"))
                    .padding(.bottom, 10)
                
            }
            .padding(.bottom, 10)
        }
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
    }
}
