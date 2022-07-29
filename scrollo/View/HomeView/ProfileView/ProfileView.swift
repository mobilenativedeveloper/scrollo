//
//  ProfileView.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import UISheetPresentationControllerCustomDetent

struct ProfileView: View {
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    @StateObject var profileController: ProfileViewModel = ProfileViewModel()
    @StateObject var postController: PostViewModel = PostViewModel()
    @StateObject private var storyViewModel: StoryViewModel = StoryViewModel()
    @State var selectedTab: ProfileTab = .media
    @State var backgroundHeader: Bool = false
    var userId: String
    let size = (UIScreen.main.bounds.width / 3) - 4
    
    // MARK: Sheets
    @State var publicationSheetPresent: Bool = false
    // MARK: Settings presenation
    @State var settingsSheetPresent: Bool = false
    @State var isPresentSettings: Bool = false
    @State var isPresentSaved: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            if let user = profileController.user {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            GeometryReader{proxy -> Color in
                                let minY = proxy.frame(in: .global).minY
                                DispatchQueue.main.async {
                                    if minY < -120 {
                                        withAnimation {
                                            backgroundHeader = true
                                        }
                                    } else {
                                        withAnimation {
                                            backgroundHeader = false
                                        }
                                    }
                                }

                                return Color.clear
                            }
                                .frame(height: 0)
                            StickyHeader(background: user.background)
                            ZStack(alignment: .top) {
                                VStack(spacing: 10) {
                                    FollowInfoView(followersCount: user.followersCount, followingCount: user.followingCount)
                                    UserInfoView(login: user.login ?? "", career: user.career, personal: user.personal)
                                    if self.userId == UserDefaults.standard.string(forKey: "userId") {
                                        NavigationLink(destination: EditUserProfile().environmentObject(profileController).ignoreDefaultHeaderBar) {
                                            HStack {
                                                Text("Редактировать профиль")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(Color(hex: "#2E313C"))
                                                    .padding(.vertical, 15)
                                            }
                                            .frame(width: UIScreen.main.bounds.width - 46)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color(hex: "#F9F9F9"))
                                                    .modifier(RoundedEdge(width: 1, color: Color(hex: "#DDE8E8"), cornerRadius: 15))
                                            )
                                            .padding(.horizontal)
                                            .padding(.top, 12)
                                        }
                                    } else {
                                        FollowUserControll(userId: userId).environmentObject(profileController)
                                    }
                                    StoriesListView()
                                        .environmentObject(storyViewModel)
                                        .fullScreenCover(isPresented: $storyViewModel.showStory) {
                                            StoryView()
                                                .environmentObject(storyViewModel)
                                        }
                                    HStack(spacing: 0) {
                                        Button(action: {
                                            self.selectedTab = .media
                                        }) {
                                            Rectangle()
                                                .stroke(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1))
                                                .overlay(
                                                    self.getTabImage(active: "profile_media_post_tab_active", inactive: "profile_media_post_tab_inactive", selection: self.selectedTab == .media)
                                                )
                                        }
                                        Button(action: {
                                            self.selectedTab = .text
                                        }) {
                                            Rectangle()
                                                .stroke(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1))
                                                .overlay(
                                                    self.getTabImage(active: "profile_text_post_tab_active", inactive: "profile_text_post_tab_inactive", selection: self.selectedTab == .text)
                                                )
                                        }
                                    }
                                    .frame(height: 55)
                                    .padding(.vertical, 21)
                                    if self.selectedTab == .media {
                                        if !postController.loadMdeiaPost {
                                            ProgressView()
                                        } else {
                                            PostCompositionView(posts: $postController.mediaPost)
                                        }
                                    } else {
                                        if postController.loadTextPost {
                                                ForEach(0..<postController.textPost.count, id: \.self) {index in
                                                    UIViewTextPost(post: $postController.textPost[index])
                                                }
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color(hex: "#F9F9F9"))
                                if let avatar = user.avatar {
                                    WebImage(url: URL(string: "\(API_URL)/uploads/\(avatar)")!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 101, height: 101, alignment: .center)
                                        .background(Color(hex: "#f7f7f7"))
                                        .cornerRadius(25)
                                        .shadow(color: Color.black.opacity(0.5), radius: 4)
                                        .offset(y: -35)
                                } else {
                                    UIDefaultAvatar(width: 101, height: 101, cornerRadius: 25, background: Color(hex: "#f7f7f7"))
                                        .shadow(color: Color.black.opacity(0.5), radius: 4)
                                        .offset(y: -35)
                                }
                            }
                        }
                        .padding(.bottom, 200)
                        .background(Color(hex: "#F9F9F9"))
                    }
                    .background(Color(hex: "#F9F9F9"))

                    HStack {
                        if self.userId == UserDefaults.standard.string(forKey: "userId") {
                            Button(action: {
                                publicationSheetPresent.toggle()
                            }, label: {
                                Image(backgroundHeader ? "circle.plus.black" : "profile_plus_icon")
                            })
                            Spacer(minLength: 0)
                            if backgroundHeader {
                                Text("\(user.login!)")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                                    .foregroundColor(Color(hex: "#2E313C"))
                            } else {
                                Text("")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                                    .foregroundColor(Color(hex: "#2E313C"))
                            }

                            Spacer(minLength: 0)
                            Button(action: {
                                settingsSheetPresent.toggle()
                            }, label: {

                                Image(backgroundHeader ? "profile_menu_icon_black" : "profile_menu_icon")
                            })
                        } else {
                            Button(action: {

                            }) {
                                Image(backgroundHeader ? "big_arrow_left_black" : "big_arrow_left_white")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .aspectRatio(contentMode: .fill)
                            }
                            Spacer(minLength: 0)
                            if backgroundHeader {
                                Text("\(user.login!)")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                                    .foregroundColor(Color(hex: "#2E313C"))
                            } else {
                                Text("")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                                    .foregroundColor(Color(hex: "#2E313C"))
                            }
                            Spacer(minLength: 0)
                            Color.clear
                                .frame(width: 24, height: 24)
                                .opacity(0)
                        }
                    }
                    .padding()
                    .background(backgroundHeader ? Color.white : Color.white.opacity(0))
                }
                .background(Color(hex: "#F9F9F9"))
                .fullScreenCover(isPresented: $storyViewModel.showStory) {
                    StoryView()
                        .environmentObject(storyViewModel)
                }
            } else {
                ProgressView()
            }
        }
        .background(
            NavigationLink(destination: SavedView().ignoreDefaultHeaderBar, isActive: $isPresentSaved) { EmptyView() }.frame(height: 0)
                .opacity(0)
        )
        .background(
            NavigationLink(destination: SettingsView().ignoreDefaultHeaderBar, isActive: $isPresentSettings) { EmptyView() }.frame(height: 0)
                .opacity(0)
        )
        .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
        .onAppear {
            profileController.getProfile(userId: userId)
            postController.getUserMediaPosts(userId: userId)
            postController.getUserTextPosts(userId: userId)
        }
        .sheetView(isPresent: $settingsSheetPresent, uiHostingController: "settingsHostingController") {
            ProfileSettinsBottomSheet(isPresentSettings: $isPresentSettings, isPresentSaved: $isPresentSaved)
        }
        .sheetView(isPresent: $publicationSheetPresent, uiHostingController: "publicationHostingController") {
            AddPublicationBottomSheetContent()
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

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}

enum ProfileTab {
    case media
    case text
}

private struct ProfileSettinsBottomSheet : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isPresentSettings: Bool
    @Binding var isPresentSaved: Bool
    
    let time: CGFloat = 0.2
    
    var body : some View {
        
        VStack {
            PrefersGrabber()
                .padding(.bottom, 25)
            Button(action: {
                print("Tap")
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
                    isPresentSaved.toggle()
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
            Button(action: {}) {
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
            Button(action: {}) {
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
                    isPresentSettings.toggle()
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
//        .padding(.bottom, 10)
    }
}


private struct AddPublicationBottomSheetContent: View {
    let sepparatorGradient: LinearGradient = LinearGradient(colors: [Color(hex: "#C4C4C4").opacity(0), Color(hex: "#C4C4C4"), Color(hex: "#C4C4C4").opacity(0)], startPoint: .leading, endPoint: .trailing)
    var body: some View {
        ZStack(alignment: .top) {
            Color.white
            
            VStack {
                PrefersGrabber()
                    .padding(.bottom, 25)
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("Добавить")
                            .font(.custom(GothamBold, size: 20))
                            .foregroundColor(Color(hex: "#2E313C"))
                            .textCase(.uppercase)
                        Spacer(minLength: 0)
                        Button(action: {}) {
                            Image("roundedRectanglePlus")
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 34)
                    self.sepparator()
                    self.addPublicationItem(icon: "publication", title: "публикацию")
                    self.sepparator()
                    self.addPublicationItem(icon: "post", title: "пост")
                    self.sepparator()
                    self.addPublicationItem(icon: "story", title: "историю")
                    self.sepparator()
                    self.addPublicationItem(icon: "actualStory", title: "актуальное из истории")
                    self.sepparator()
                }
            }
        }
        .ignoresSafeArea()
    }
    @ViewBuilder
    private func sepparator() -> some View {
        Rectangle()
            .fill(sepparatorGradient)
            .frame(height: 1)
    }
    @ViewBuilder
    private func addPublicationItem(icon: String, title: String) -> some View {
        Button(action: {}) {
            HStack(spacing: 0) {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 23, height: 23)
                    .padding(.trailing, 14)
                Text(title)                     .font(.custom(GothamBook, size: 16))
                    .textCase(.uppercase)
                    .foregroundColor(.black)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
        }
    }
}
