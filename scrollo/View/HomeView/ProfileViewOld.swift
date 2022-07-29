////
////  Profile.swift
////  scrollo
////
////  Created by Artem Strelnik on 06.07.2022.
////
//
//import SwiftUI
//import SDWebImageSwiftUI
//
//enum ProfileTab {
//    case media
//    case text
//}
//
////struct ProfileView: View {
////    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
////    @EnvironmentObject var bottomSheetViewModel : BottomSheetViewModel
////    @StateObject private var profile: ProfileViewModel = ProfileViewModel()
////    @StateObject private var storyViewModel: StoryViewModel = StoryViewModel()
////    @State var selectedTab: ProfileTab = .media
////    @State var backgroundHeader: Bool = false
////    private let userId: String
////    let size = (UIScreen.main.bounds.width / 3) - 4
////    init (userId: String) {
////        self.userId = userId
////    }
////
////    var body: some View {
////
////        VStack(spacing: 0) {
////            if let user = profile.user {
////
////                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
////
////                    ScrollView(showsIndicators: false) {
////
////                        VStack {
////                            GeometryReader{proxy -> Color in
////                                let minY = proxy.frame(in: .global).minY
////                                DispatchQueue.main.async {
////                                    if minY < -120 {
////                                        withAnimation {
////                                            backgroundHeader = true
////                                        }
////                                    } else {
////                                        withAnimation {
////                                            backgroundHeader = false
////                                        }
////                                    }
////                                }
////
////                                return Color.clear
////                            }
////                                .frame(height: 0)
////                            self.StickyHeader(background: user.background)
////
////                            ZStack(alignment: .top) {
////                                VStack(spacing: 10) {
////                                    HStack {
////                                        VStack {
////                                            Text("\(user.followersCount)")
////                                                .font(.system(size: 21))
////                                                .fontWeight(.bold)
////                                                .foregroundColor(Color(hex: "#1F2128"))
////                                            Text("подписчики")
////                                                .font(.system(size: 11))
////                                                .foregroundColor(Color(hex: "#828796"))
////                                        }
////                                        Spacer()
////                                        VStack {
////                                            Text("\(user.followingCount)")
////                                                .font(.system(size: 21))
////                                                .fontWeight(.bold)
////                                                .foregroundColor(Color(hex: "#1F2128"))
////                                            Text("подписки")
////                                                .font(.system(size: 11))
////                                                .foregroundColor(Color(hex: "#828796"))
////                                        }
////                                    }
////                                    .padding(.top, 28)
////                                    .padding(.horizontal, 33)
////                                    VStack{
////                                        Text("\(user.login!)")
////                                            .font(.system(size: 18))
////                                            .fontWeight(.bold)
////                                            .foregroundColor(Color(hex: "#1F2128"))
////                                        if let career = user.career {
////                                            if career != "" {
////                                                Text(career)
////                                                    .font(.system(size: 12))
////                                                    .foregroundColor(Color(hex: "#5B86E5"))
////                                                    .padding(.top, 1)
////                                            }
////                                        }
////                                        if let bio = user.personal?.bio {
////                                            if bio != "" {
////                                                Text(bio)
////                                                    .font(.system(size: 11))
////                                                    .foregroundColor(Color(hex: "#828796"))
////                                                    .multilineTextAlignment(.center)
////                                                    .padding(.horizontal, 50)
////                                                    .padding(.top, 2)
////                                            }
////                                        }
////                                        if let website = user.personal?.website {
////                                            if website != "" {
////                                                Text(website)
////                                                    .font(.system(size: 12))
////                                                    .foregroundColor(Color.blue)
////                                                    .padding(.top, 1)
////                                            }
////                                        }
////                                    }
////                                    .frame(width: UIScreen.main.bounds.width)
////                                    .padding(.top, 10)
////                                    if self.userId == UserDefaults.standard.string(forKey: "userId") {
////                                        NavigationLink(destination: EditUserProfile().environmentObject(profile).ignoreDefaultHeaderBar) {
////                                            HStack {
////                                                Text("Редактировать профиль")
////                                                    .font(.system(size: 14))
////                                                    .foregroundColor(Color(hex: "#2E313C"))
////                                                    .padding(.vertical, 15)
////                                            }
////                                            .frame(width: UIScreen.main.bounds.width - 46)
////                                            .background(
////                                                RoundedRectangle(cornerRadius: 10)
////                                                    .fill(Color(hex: "#F9F9F9"))
////                                                    .modifier(RoundedEdge(width: 1, color: Color(hex: "#DDE8E8"), cornerRadius: 15))
////                                            )
////                                            .padding(.horizontal)
////                                            .padding(.top, 12)
////                                        }
////                                    } else {
////                                        FollowUserControll(userId: userId).environmentObject(profile)
////                                    }
////
//////                                    StoriesList()
//////                                        .padding(.top, 27)
//////                                        .environmentObject(self.storyViewModel)
////                                    HStack(spacing: 0) {
////                                        Button(action: {
////                                            self.selectedTab = .media
////                                        }) {
////                                            Rectangle()
////                                                .stroke(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1))
////                                                .overlay(
////                                                    self.getTabImage(active: "profile_media_post_tab_active", inactive: "profile_media_post_tab_inactive", selection: self.selectedTab == .media)
////                                                )
////                                        }
////                                        Button(action: {
////                                            self.selectedTab = .text
////                                        }) {
////                                            Rectangle()
////                                                .stroke(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1))
////                                                .overlay(
////                                                    self.getTabImage(active: "profile_text_post_tab_active", inactive: "profile_text_post_tab_inactive", selection: self.selectedTab == .text)
////                                                )
////                                        }
////                                    }
////                                    .frame(height: 55)
////                                    .padding(.vertical, 21)
////                                    if self.selectedTab == .media {
////                                        if !profile.loadMdeiaPost {
////                                            ProgressView()
////                                        } else {
//////                                            ForEach(0..<profile.mediaPost.count, id: \.self) {index in
//////                                                Layout4(postComposition: $profile.mediaPost[index])
//////                                                    .environmentObject(bottomSheetViewModel)
//////                                            }
//////                                            Layout()
//////                                                .environmentObject(bottomSheetViewModel)
//////                                                .environmentObject(profile)
////                                        }
////                                    } else {
////                                        if profile.loadTextPost {
//////                                            ForEach(0..<profile.textPost.count, id: \.self) {index in
//////                                                UIPostTextView(post: $profile.textPost[index])
//////                                                    .environmentObject(bottomSheetViewModel)
//////                                            }
////                                        } else {
////                                            ProgressView()
////                                        }
////                                    }
////                                }
////                                .frame(maxWidth: .infinity, maxHeight: .infinity)
////                                .background(Color(hex: "#F9F9F9"))
////
////                                if let avatar = user.avatar {
////                                    WebImage(url: URL(string: "\(API_URL)/uploads/\(avatar)")!)
////                                        .resizable()
////                                        .aspectRatio(contentMode: .fill)
////                                        .frame(width: 101, height: 101, alignment: .center)
////                                        .background(Color(hex: "#f7f7f7"))
////                                        .cornerRadius(25)
////                                        .shadow(color: Color.black.opacity(0.5), radius: 4)
////                                        .offset(y: -35)
////                                } else {
////                                    UIDefaultAvatar(width: 101, height: 101, cornerRadius: 25, background: Color(hex: "#f7f7f7"))
////                                        .shadow(color: Color.black.opacity(0.5), radius: 4)
////                                        .offset(y: -35)
////                                }
////                            }
////                        }
////                        .padding(.bottom, 200)
////                        .background(Color(hex: "#F9F9F9"))
////                    }
////                    .background(Color(hex: "#F9F9F9"))
////
////                    HStack{
////                        if self.userId == UserDefaults.standard.string(forKey: "userId") {
////                            Button(action: {
////                                bottomSheetViewModel.presentAddPublication.toggle()
////                            }, label: {
////                                Image(backgroundHeader ? "circle.plus.black" : "profile_plus_icon")
////                            })
////                            Spacer(minLength: 0)
////                            if backgroundHeader {
////                                Text("\(user.login!)")
////                                    .font(.system(size: 20))
////                                    .fontWeight(.bold)
////                                    .textCase(.uppercase)
////                                    .foregroundColor(Color(hex: "#2E313C"))
////                            } else {
////                                Text("")
////                                    .font(.system(size: 20))
////                                    .fontWeight(.bold)
////                                    .textCase(.uppercase)
////                                    .foregroundColor(Color(hex: "#2E313C"))
////                            }
////
////                            Spacer(minLength: 0)
////                            Button(action: {
////                                bottomSheetViewModel.profileSettingsBottomSheet.toggle()
////                            }, label: {
////
////                                Image(backgroundHeader ? "profile_menu_icon_black" : "profile_menu_icon")
////                            })
////                        } else {
////                            Button(action: {
////                                presentation.wrappedValue.dismiss()
////                            }) {
////                                Image(backgroundHeader ? "big_arrow_left_black" : "big_arrow_left_white")
////                                    .resizable()
////                                    .frame(width: 24, height: 24)
////                                    .aspectRatio(contentMode: .fill)
////                            }
////                            Spacer(minLength: 0)
////                            if backgroundHeader {
////                                Text("\(user.login!)")
////                                    .font(.system(size: 20))
////                                    .fontWeight(.bold)
////                                    .textCase(.uppercase)
////                                    .foregroundColor(Color(hex: "#2E313C"))
////                            } else {
////                                Text("")
////                                    .font(.system(size: 20))
////                                    .fontWeight(.bold)
////                                    .textCase(.uppercase)
////                                    .foregroundColor(Color(hex: "#2E313C"))
////                            }
////                            Spacer(minLength: 0)
////                            Color.clear
////                                .frame(width: 24, height: 24)
////                                .opacity(0)
////                        }
////
////                    }
////                    .padding()
////                    .background(backgroundHeader ? Color.white : Color.white.opacity(0))
////                }
////                .background(Color(hex: "#F9F9F9"))
//////                .fullScreenCover(isPresented: self.$storyViewModel.showStory) {
//////                    StoryView()
//////                        .environmentObject(storyViewModel)
//////                }
////            } else {
////                ProgressView()
////            }
////
////        }
////        .background(Color(hex: "#F9F9F9"))
//        .onAppear {
//            profile.getProfile(userId: self.userId)
//            profile.getUserMediaPosts(userId: userId)
//            profile.getUserTextPosts(userId: userId)
//        }
////    }
////    @ViewBuilder
////    private func StickyHeader(background: String?) -> some View {
////        let height: CGFloat = 150
////        GeometryReader{reader in
////            let minY = reader.frame(in: .global).minY
////            if let background = background {
////                AnimatedImage(url: URL(string: "\(API_URL)/uploads/\(background)")!)
////                    .resizable()
////                    .aspectRatio(contentMode: .fill)
////                    .frame(width: UIScreen.main.bounds.width, height: minY > 0 ? minY + height : height)
////                    .background(Color(hex: "#f7f7f7"))
////                    .offset(y: -minY)
////            } else {
////
////                LinearGradient(colors: [
////                    Color(hex: "#5B86E5"),
////                    Color(hex: "#36DCD8")
////                ], startPoint: .trailing, endPoint: .leading)
////                    .frame(width: UIScreen.main.bounds.width, height: minY > 0 ? minY + height : height)
////                    .offset(y: -minY)
////            }
////
////        }
////        .frame(height: height)
////    }
////
////    @ViewBuilder
////    private func getTabImage(active: String, inactive: String, selection: Bool) -> some View {
////        let image: String = selection ? active : inactive
////        Image(image)
////            .resizable()
////            .aspectRatio(contentMode: .fit)
////            .frame(width: 22, height: 22)
////    }
////}
//
//struct FollowUserControll: View {
//    @State var load: Bool = false
//    @State var followOnHim: Bool = false
//    let userId: String
//    @EnvironmentObject var profile: ProfileViewModel
//
//    init (userId: String) {
//        self.userId = userId
//    }
//
//    var body: some View {
//        HStack {
//            Spacer()
//            Button(action: {
//                if !self.load {
//                    self.handleFollow()
//                }
//            }) {
//                RoundedRectangle(cornerRadius: 15)
//                    .fill(Color(hex: self.followOnHim ? "#36DCD8" : "#5B86E5"))
//                    .frame(width: 151, height: 45, alignment: .center)
//                    .overlay(
//                        self.Loading(),
//                        alignment: .center
//                    )
//            }
//            Spacer(minLength: 10)
//            Button(action: {}) {
//                Capsule(style: .continuous)
//                    .stroke(Color(hex: "#DDE8E8"), style: StrokeStyle(lineWidth: 1))
//                    .frame(width: 151, height: 45, alignment: .center)
//                    .overlay(
//                        Text("Написать")
//                            .foregroundColor(Color(hex: "#2E313C")),
//                        alignment: .center
//                    )
//            }
//            Spacer()
//        }
//        .padding(.top, 14)
//        .onAppear(perform: {
//            profile.checkFollowOnUser(userId: userId, completion: {status in
//                if let status = status {
//                    if status {
//                        self.followOnHim = true
//                    } else {
//                        self.followOnHim = false
//                    }
//                }
//            })
//        })
//    }
//
//    @ViewBuilder
//    private func Loading() -> some View {
//        if self.load {
//            ProgressView()
//        } else {
//            Text(self.followOnHim ? "Вы Подписаны" : "Подписаться")
//                .foregroundColor(Color.white)
//        }
//    }
//
//    private func handleFollow() {
//        self.load = true
//        if self.followOnHim {
//            profile.unFollowOnUser(userId: userId, completion: {
//                DispatchQueue.main.async {
//                    self.followOnHim = false
//                    self.load = false
//                }
//            })
//        } else {
//            profile.followOnUser(userId: userId, completion: {
//                DispatchQueue.main.async {
//                    self.followOnHim = true
//                    self.load = false
//                }
//            })
//        }
//    }
//}
//
//
//struct MediaPostThumb: View {
//    var image: URL
//    var width: CGFloat
//    var height: CGFloat
//
//    var body: some View {
//
//        WebImage(url: image)
//            .resizable()
//            .frame(width: self.width, height: self.height)
//            .cornerRadius(6)
//    }
//}
//
//struct MediaPostVideo: View {
//    @StateObject var videoThumbnailViewModel: VideoThumbnailViewModel = VideoThumbnailViewModel()
//    var video: URL
//    var width: CGFloat
//    var height: CGFloat
//
//    var body: some View {
//        Image(uiImage: videoThumbnailViewModel.thumbnailVideo)
//            .resizable()
//            .frame(width: self.width, height: self.height)
//            .background(Color.gray.opacity(0.5))
//            .cornerRadius(6)
//            .onAppear{
//                if !videoThumbnailViewModel.error {
//                    videoThumbnailViewModel.createThumbnailFromVideo(url: video)
//                }
//            }
//    }
//}
//
//struct Layout : View {
//    @EnvironmentObject var bottomSheetViewModel: BottomSheetViewModel
//    @EnvironmentObject var profile: ProfileViewModel
//
//    let size = (UIScreen.main.bounds.width / 3) - 4
//    var body : some View {
//
//        ForEach(0..<profile.mediaPost.count, id: \.self) {i in
//
//            HStack(alignment: .top, spacing: 4) {
//
//                ForEach(0..<profile.mediaPost[i].count, id: \.self) {j in
////                    Column(detail: $detail, column: profile.mediaPost[i][j], j: j).environmentObject(bottomSheetViewModel)
//                }
//                if profile.mediaPost[i].count == 1 || profile.mediaPost[i].count == 2 {
//                    Spacer()
//                }
//            }
//        }
//    }
//}
//
//
//struct Column : View {
//    @EnvironmentObject var bottomSheetViewModel: BottomSheetViewModel
//    @Binding var detail: PostModel
//    @State var isDetail: Bool = false
//    let size = (UIScreen.main.bounds.width / 3) - 4
//    var column: [PostModel]
//    var j: Int
//    var body : some View {
//
//        VStack(alignment: .leading, spacing: 4) {
//
//            ForEach(0..<column.count, id: \.self) {k in
//
//                if j == 0 && k == 0{
//                    //MARK: size size
//                    if column[k].files[0].type == "IMAGE" {
//                        MediaPostThumb(image:  URL(string: "\(API_URL)/uploads/\(column[k].files[0].filePath!)")!, width: size, height: size)
//                    } else {
//                        MediaPostVideo(video: URL(string: "\(API_URL)/uploads/\(column[k].files[0].filePath!)")!, width: size, height: size)
//                    }
//                }
//                if j == 0 && k == 1{
//                    //MARK: size size + 50
//                    if column[k].files[0].type == "IMAGE" {
//                        MediaPostThumb(image:  URL(string: "\(API_URL)/uploads/\(column[k].files[0].filePath!)")!, width: size, height: size + 50)
//                    } else {
//                        MediaPostVideo(video: URL(string: "\(API_URL)/uploads/\(column[k].files[0].filePath!)")!, width: size, height: size + 50)
//                    }
//                }
//                if j == 1 && k == 0{
//                    //MARK: size size + 50
//                    if column[k].files[0].type == "IMAGE" {
//                        MediaPostThumb(image:  URL(string: "\(API_URL)/uploads/\(column[k].files[0].filePath!)")!, width: size, height: size + 50)
//                    } else {
//                        MediaPostVideo(video: URL(string: "\(API_URL)/uploads/\(column[k].files[0].filePath!)")!, width: size, height: size + 50)
//                    }
//                }
//                if j == 1 && k == 1{
//                    //MARK: size size
//                    if column[k].files[0].type == "IMAGE" {
//                        MediaPostThumb(image:  URL(string: "\(API_URL)/uploads/\(column[k].files[0].filePath!)")!, width: size, height: size)
//                    } else {
//                        MediaPostVideo(video: URL(string: "\(API_URL)/uploads/\(column[k].files[0].filePath!)")!, width: size, height: size)
//                    }
//                }
//                if j == 2 && k == 0{
//                    //MARK: size size
//                    if column[k].files[0].type == "IMAGE" {
//                        MediaPostThumb(image:  URL(string: "\(API_URL)/uploads/\(column[k].files[0].filePath!)")!, width: size, height: size)
//                    } else {
//                        MediaPostVideo(video: URL(string: "\(API_URL)/uploads/\(column[k].files[0].filePath!)")!, width: size, height: size)
//                    }
//                }
//                if j == 2 && k == 1{
//                    //MARK: size size + 50
//                    if column[k].files[0].type == "IMAGE" {
//                        MediaPostThumb(image:  URL(string: "\(API_URL)/uploads/\(column[k].files[0].filePath!)")!, width: size, height: size + 50)
//                    } else {
//                        MediaPostVideo(video: URL(string: "\(API_URL)/uploads/\(column[k].files[0].filePath!)")!, width: size, height: size + 50)
//                    }
//                }
//
//            }
//        }
//
//    }
//}
//
//struct Layout4 : View {
////    @EnvironmentObject var storyViewModel: StoryViewModel
////    @EnvironmentObject var postViewModel: PostViewModel
////    @EnvironmentObject var loginViewModel: LoginViewModel
//    @EnvironmentObject var bottomSheetViewModel: BottomSheetViewModel
//    @Binding var postComposition: [PostModel]
//    let width = (UIScreen.main.bounds.width / 3) - 16
//
//    init (postComposition: Binding<[PostModel]>) {
//        self._postComposition = postComposition
//    }
//
//    var body : some View {
//        HStack(spacing: 8) {
//            VStack(spacing: 8) {
//                if self.postComposition.count == 1 {
//                    PostContent(post: self.$postComposition[0], type: self.postComposition[0].files[0].type ?? "", w: width, h: 121, content: self.postComposition[0].files[0].filePath  ?? "").environmentObject(bottomSheetViewModel)
//                } else if self.postComposition.count >= 4 {
//                    PostContent(post: self.$postComposition[0], type: self.postComposition[0].files[0].type ?? "", w: width, h: 121, content: self.postComposition[0].files[0].filePath  ?? "").environmentObject(bottomSheetViewModel)
//
//                    PostContent(post: self.$postComposition[3], type: self.postComposition[3].files[0].type ?? "", w: width, h: 189, content: self.postComposition[3].files[0].filePath  ?? "").environmentObject(bottomSheetViewModel)
//                }
//            }
//            VStack(spacing: 8) {
//                if self.postComposition.count == 2 {
//                    PostContent(post: self.$postComposition[1], type: self.postComposition[1].files[0].type ?? "", w: width, h: 189, content: self.postComposition[1].files[0].filePath  ?? "").environmentObject(bottomSheetViewModel)
//
//
//                } else if self.postComposition.count >= 5 {
//                    PostContent(post: self.$postComposition[1], type: self.postComposition[1].files[0].type ?? "", w: width, h: 189, content: self.postComposition[1].files[0].filePath  ?? "").environmentObject(bottomSheetViewModel)
//
//                    PostContent(post: self.$postComposition[4], type: self.postComposition[4].files[0].type ?? "", w: width, h: 121, content: self.postComposition[4].files[0].filePath  ?? "").environmentObject(bottomSheetViewModel)
//                }
//            }
//            VStack(spacing: 8) {
//                if self.postComposition.count == 3 {
//                    PostContent(post: self.$postComposition[2], type: self.postComposition[2].files[0].type ?? "", w: width, h: 121, content: self.postComposition[2].files[0].filePath  ?? "").environmentObject(bottomSheetViewModel)
//
//                } else if self.postComposition.count == 6 {
//                    PostContent(post: self.$postComposition[2], type: self.postComposition[2].files[0].type ?? "", w: width, h: 121, content: self.postComposition[2].files[0].filePath  ?? "").environmentObject(bottomSheetViewModel)
//                    PostContent(post: self.$postComposition[5], type: self.postComposition[5].files[0].type ?? "", w: width, h: 189, content: self.postComposition[5].files[0].filePath  ?? "").environmentObject(bottomSheetViewModel)
//                }
//            }
//        }
//    }
//}
//
//struct PostContent: View {
//    @EnvironmentObject var bottomSheetViewModel: BottomSheetViewModel
//    @Binding var post: PostModel
//    var type: String
//    var w: CGFloat
//    var h: CGFloat
//    var content: String
//
//
//    var body : some View {
//
//        if type == "IMAGE" {
//            NavigationLink(destination: {
//                PostDetailView(post: $post)
//                                .ignoreDefaultHeaderBar
//                                .environmentObject(bottomSheetViewModel)
//            }) {
//                WebImage(url: URL(string: "\(API_URL)/uploads/\(content)")!)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: w, height: h)
//                    .cornerRadius(6)
//            }
//        } else {
//            Color.gray
//                .frame(width: w, height: h)
//                .cornerRadius(6)
//        }
//    }
//}
