////
////  AppNotificationCenter.swift
////  scrollo
////
////  Created by Artem Strelnik on 20.08.2022.
////
//
//import SwiftUI
//
//struct AppNotificationCenter<Content: View> : View {
//    @StateObject var bottomSheets: BottomSheetViewModel = BottomSheetViewModel()
//    let content: Content
//    
//    init (content: @escaping () -> Content) {
//        self.content = content()
//    }
//    
//    var body : some View {
//        content
//            .onAppear {
//                NotificationCenter.default.addObserver(forName: NSNotification.Name(openPostActionsSheet), object: nil, queue: .main) { (notification) in
//                    guard let postId = notification.userInfo?["postId"] as? String else {return}
//                    if !bottomSheets.postActionsSheet {
//                        bottomSheets.postActionsSheetPostId = postId
//                        bottomSheets.postActionsSheet = true
//                    }
//                }
//            }
//    }
//}
//
////            .bottomSheet(isOpen: $bottomSheets.postActionsSheet, backgroundColor: Color.white, prefersGrabberVisible: true, detents: [.custom(549)], content: {
////                PostActionsSheet(postId: bottomSheets.postActionsSheetPostId)
////                    .environmentObject(bottomSheets)
////            })
