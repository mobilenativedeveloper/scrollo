//
//  SearchHistoryViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 23.06.2022.
//

import SwiftUI

class SearchHistoryViewModel : ObservableObject {
    @Published var isSearch : Bool = false
    @Published var usersSearchHistory : [String] = []
    
    init () {
        let userDefaults = UserDefaults.standard
        let strings = userDefaults.object(forKey: "usersSearchHistory")
        
        if let _ = strings {
            //
        } else {
            let array: [String] = []
            userDefaults.set(array, forKey: "usersSearchHistory")
        }
    }
    
    func getUsersSearchedHistory () -> Void {
        let userDefaults = UserDefaults.standard
        let strings = userDefaults.object(forKey: "usersSearchHistory")
        if let strings = strings {
            self.usersSearchHistory = strings as! [String]
        }
    }
    
    func saveUserSearchedHistory (user: String) -> Void {
        
        if let storedStrings = UserDefaults.standard.object(forKey: "usersSearchHistory") {
            
            var newHistoryList: [String] = []
            newHistoryList += storedStrings as! [String]
            newHistoryList.append(user)
            
            UserDefaults.standard.set(newHistoryList, forKey: "usersSearchHistory")
            
            self.getUsersSearchedHistory()
        }
    }
    
    func removeUserSearchedHistory (user: String) -> Void {
        if let index = self.usersSearchHistory.firstIndex(of: user) {
            self.usersSearchHistory.remove(at: index)
            
            UserDefaults.standard.set(self.usersSearchHistory, forKey: "usersSearchHistory")
        }
    }
    
    func removeAllUsersSearchedHistory () -> Void {
        self.usersSearchHistory.removeAll()
        
        UserDefaults.standard.set([], forKey: "usersSearchHistory")
    }
}

