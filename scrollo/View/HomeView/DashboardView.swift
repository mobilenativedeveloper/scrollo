//
//  DashboardView.swift
//  scrollo
//
//  Created by Artem Strelnik on 20.08.2022.
//

import SwiftUI

struct DashboardView: View {
    @State var selectedTab = "home"
    @State var upload: Bool = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection: $selectedTab){
                FeedView()
                    .ignoresSafeArea(SafeAreaRegions.container, edges: .bottom)
                    .ignoreDefaultHeaderBar
                    .tag("home")
                SearchView()
                    .ignoreDefaultHeaderBar
                    .tag("search")
                ActivitiesView()
                    .ignoreDefaultHeaderBar
                    .tag("activities")
                ProfileView(userId: UserDefaults.standard.string(forKey: "userId")!)
                    .ignoresSafeArea(SafeAreaRegions.container, edges: .bottom)
                    .ignoreDefaultHeaderBar
                    .tag("profile")
            }
            
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                if self.upload {
                    BlurView(style: .light)
                        .opacity(0.8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea(.all, edges: .all)
                        .onTapGesture {
                            withAnimation {
                                self.upload = false
                            }
                        }
                }
                TabBar(selectedTab: $selectedTab, upload: $upload)
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
