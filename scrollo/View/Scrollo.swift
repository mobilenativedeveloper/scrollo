//
//  Scrollo.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

struct Scrollo: View {
    @State var userId: String = UserDefaults.standard.value(forKey: "userId") as? String ?? String()
    
    init () {
        UIWindow.appearance().overrideUserInterfaceStyle = .light
        UITabBar.appearance().isHidden = true
            
    }
    
    var body: some View {
        
        NavigationView {
            if self.userId.isEmpty {
                LoginView()
                    .ignoreDefaultHeaderBar
            } else {
                HomeView()
                    .ignoreDefaultHeaderBar
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("userId"), object: nil, queue: .main) { (_) in
                self.userId = UserDefaults.standard.value(forKey: "userId") as? String ?? String()
            }
        }
    }
}

struct Scrollo_Previews: PreviewProvider {
    static var previews: some View {
        Scrollo()
    }
}
