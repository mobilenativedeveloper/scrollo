//
//  RecentUserSearchQueries.swift
//  scrollo
//
//  Created by Artem Strelnik on 23.06.2022.
//

import SwiftUI

struct RecentUserSearchQueries: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var searchHistoryViewModel : SearchHistoryViewModel
    @State var removeAlert : Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("circle.left.arrow")
                            .foregroundColor(.black)
                    }
                    .frame(width: 24, alignment: .leading)
                    Spacer(minLength: 0)
                    Text("Недавние запросы")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .foregroundColor(Color(hex: "#1F2128"))
                    Spacer(minLength: 0)
                    Button(action: {
                        self.removeAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(searchHistoryViewModel.usersSearchHistory.count == 0 ? .gray : .red)
                    }
                    .frame(width: 24)
                }
                .padding()
                .background(Color.white)
                
                List {
                    if searchHistoryViewModel.usersSearchHistory.count == 0 {
                        Text("Нет истории поиска")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(0..<searchHistoryViewModel.usersSearchHistory.count, id: \.self) {index in
                            UserSearchHistoryView(name: searchHistoryViewModel.usersSearchHistory[index])
                                .environmentObject(searchHistoryViewModel)
                        }
                        .padding(.horizontal, 15)
                        .padding(.bottom, 28)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(.clear)
                    }
                   
                }
                .listStyle(.plain)
            }
        }
        .alert(isPresented: self.$removeAlert) {
            Alert(title: Text("Очистить историю поиска?"), message: Text("Вы не сможете отменить это действие. Если вы очистите историю поиска, аккаунты, которые вы искали, могут по-прежнему отображаться в рекомендуемых результатах."), primaryButton: .destructive(Text("Очистить все")) {
                searchHistoryViewModel.removeAllUsersSearchedHistory()
            }, secondaryButton: .cancel(Text("Не сейчас").foregroundColor(.red)))
        }
    }
}

struct RecentUserSearchQueries_Previews: PreviewProvider {
    static var previews: some View {
        RecentUserSearchQueries()
    }
}


