//
//  ProfileView.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//
import SwiftUI
import SDWebImageSwiftUI
import UISheetPresentationControllerCustomDetent

enum ProfileTab { case media, text }

enum SheetContent { case publication, settings }

struct ProfileView: View {
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    @StateObject var profileController: ProfileViewModel = ProfileViewModel()
    @StateObject var postController: PostViewModel = PostViewModel()
    @StateObject private var storyViewModel: StoryViewModel = StoryViewModel()
    @State var selectedTab: ProfileTab = .media
    //MARK: header animation
    @State var backgroundHeader: Bool = false
    //MARK: sheets
    @State var publicationSheet: Bool = false
    @State var settingsSheet: Bool = false
    
    @State var sheet: Bool = false
    @State var sheetContent: SheetContent = .publication
    
    @State var isPresentActualStoryView: Bool = false
    
    let userId: String
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            
            if let user = profileController.user {
                if let background = user.background {
                    GeometryReader {reader in
                        WebImage(url: URL(string: "\(API_URL)/uploads/\(background)")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: reader.size.width, height: 150)
                    }
                } else {
                    LinearGradient(colors: [
                        Color(hex: "#5B86E5"),
                        Color(hex: "#36DCD8")
                    ], startPoint: .trailing, endPoint: .leading)
                        .frame(width: UIScreen.main.bounds.width, height: 150)
                }
                
                GeometryReader{reader in
                    ScrollView(.vertical, showsIndicators: false) {
                        Color.clear.frame(height: 150)
                        
                        ZStack(alignment: .top) {
                            
                            VStack(spacing: 10) {
                                GeometryReader{proxy -> Color in
                                    let minY = proxy.frame(in: .global).minY
                                    DispatchQueue.main.async {
                                        print(minY)
                                        if minY < 86 {
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
                                FollowInfoView(followersCount: user.followersCount, followingCount: user.followingCount)
                                UserInfoView(login: user.login ?? "", career: user.career, personal: user.personal)
                                Text("publicationSheet \(publicationSheet ? "true" : "false")")
                                Text("settingsSheet \(settingsSheet ? "true" : "false")")
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
                                    FollowUserControll(userId: userId)
                                        .environmentObject(profileController)
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
                                                Image(self.selectedTab == .media ? "profile_media_post_tab_active" : "profile_media_post_tab_inactive")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 22, height: 22)
                                            )
                                    }
                                    Button(action: {
                                        self.selectedTab = .text
                                    }) {
                                        Rectangle()
                                            .stroke(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1))
                                            .overlay(
                                                Image(self.selectedTab == .text ? "profile_text_post_tab_active" : "profile_text_post_tab_inactive")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 22, height: 22)
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
                                Spacer()
                            }
                            .frame(width: reader.size.width, height: reader.size.height)
                            .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
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
                    .frame(width: reader.size.width, height: reader.size.height)
                }
                
                HStack {
                    if self.userId == UserDefaults.standard.string(forKey: "userId") {
                        Button(action: {
                            sheetContent = .publication
                            sheet.toggle()
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
                            sheetContent = .settings
                            sheet.toggle()
                        }, label: {
                            Image(backgroundHeader ? "profile_menu_icon_black" : "profile_menu_icon")
                        })
                    } else {
                        Button(action: {
                            presentation.wrappedValue.dismiss()
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
            
        }
        .background(Color(hex: "#F9F9F9").edgesIgnoringSafeArea(.all))
        .fullScreenCover(isPresented: $isPresentActualStoryView, onDismiss: {}, content: {
            ActualStoryView()
        })
        .sheetView(
            isPresent: $sheet,
            backgroundColor: Color.clear,
            prefersGrabberVisible: sheetContent == .publication ? true : false,
            detents: sheetContent == .publication ? [
                .custom(549)
            ] : [
                .custom(440)
            ],
            content: {
                getSheetContent()
            }
        )
        .onAppear {
            profileController.getProfile(userId: userId)
            postController.getUserMediaPosts(userId: userId)
            postController.getUserTextPosts(userId: userId)
        }
    }

//    
    @ViewBuilder
    func getSheetContent () -> some View {
        if sheetContent == .publication {
            AddPublicationSheet(isPresentActualStoryView: $isPresentActualStoryView)
        } else {
            SettingsSheet()
        }
    }
}

