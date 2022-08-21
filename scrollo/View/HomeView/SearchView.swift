//
//  SearchView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    @StateObject var searchViewModel : SearchViewModel = SearchViewModel()
    @StateObject var searchHistoryViewModel : SearchHistoryViewModel = SearchHistoryViewModel()
    @FocusState private var isSearch : Bool
    @State private var searchTextFieldOnLongPressColor : Color = Color.primary.opacity(0.06)
    
    var body: some View {
        ZStack(alignment: .top) {

            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {

                HStack {
                    VStack (spacing: 0) {
                        HStack(spacing: 0) {
                            HStack {
                                TextField("Поиск", text: self.$searchViewModel.searchText)
                                    .focused(self.$isSearch)
                                    .onSubmit {
                                        if self.searchViewModel.searchText.count > 0 {
                                            self.searchHistoryViewModel.saveUserSearchedHistory(user: self.searchViewModel.searchText)
                                        }
                                    }
                                    .onChange(of: self.isSearch) { newValue in
                                        if !self.searchHistoryViewModel.isSearch && newValue {
                                            withAnimation(.default) {
                                                self.searchHistoryViewModel.isSearch = true
                                            }
                                        }
                                    }
                                if self.searchViewModel.searchText.count > 0 {
                                    Button(action: {
                                        self.searchViewModel.searchText = ""
                                    }) {
                                        Image(systemName: "multiply.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(Color.gray)
                                    }
                                } else {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title3)
                                        .foregroundColor(Color.gray)
                                }

                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .background(self.searchTextFieldOnLongPressColor)
                            .cornerRadius(10)
                            .padding(self.searchHistoryViewModel.isSearch ? .leading : .horizontal)
                            .onTapGesture(perform: {
                                self.isSearch = true
                            })
                            .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 100, pressing: {
                                                        pressing in
                                if pressing {
                                    self.searchTextFieldOnLongPressColor = Color.primary.opacity(0.08)
                                }
                                if !pressing {
                                    self.searchTextFieldOnLongPressColor = Color.primary.opacity(0.06)
                                }
                            }, perform: {})

                            if self.searchHistoryViewModel.isSearch {
                                Button(action: {
                                    withAnimation(.default) {
                                        self.searchHistoryViewModel.isSearch = false
                                        self.searchViewModel.searchText = String()
                                        UIApplication.shared.endEditing()
                                    }
                                }) {
                                    Text("Отмена")
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal)
                            }
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(0..<10, id: \.self) {index in
                                    HashTagButtom(index: index, title: "ThisTag")
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 18)
                        .frame(height: self.searchHistoryViewModel.isSearch ? 0 : nil)
                        .opacity(self.searchHistoryViewModel.isSearch ? 0 : 1)
                    }
                }
                .background(Color.white)

                ZStack(alignment: .top) {
                    List {
                        if let images = self.searchViewModel.images {
                            SearchCompositionLayout(items: images, id: \.id, spacing: 11) {item in
                                GeometryReader{proxy in

                                let size = proxy.size

                                WebImage(url: URL(string: item.download_url))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width, height: size.height)
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 23)
                            .padding(.bottom, 200)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(.clear)
                        } else {
                            HStack {
                                Spacer(minLength: 0)
                                ProgressView()
                                Spacer(minLength: 0)
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(.clear)
                        }

                    }
                    .listStyle(.plain)
                    .refreshable {

                    }
                    if self.searchHistoryViewModel.isSearch {
                        SearchLayer()
                            .environmentObject(self.searchViewModel)
                            .environmentObject(self.searchHistoryViewModel)
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

private struct HashTagButtom : View {
    
    @State private var isActive : Bool = false
    
    private let index : Int
    private let title : String
    
    init (index : Int, title : String) {
        self.index = index
        self.title = title
    }
    
    var body: some View {
        Button(action: {
            self.isActive.toggle()
        }) {
            Text("# \(self.title)")
                .font(Font.custom(GothamBook, size: 12))
                .foregroundColor(Color(hex: "#5B86E5"))
                .padding(.horizontal, 11)
                .padding(.vertical, 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(self.isActive ? Color(hex: "#5B86E5") : Color(hex: "#5B86E5").opacity(0.1), lineWidth: 1)
                )
        }
        .background(self.isActive ? Color.white : Color(hex: "#5B86E5").opacity(0.1)).cornerRadius(7)
        .padding(.trailing, self.index == 9 ? 0 : 8)
        .onAppear {
            self.isActive = index == 0 ? true : false
        }
    }
}

private struct SearchUserItem: View {
    @State var isPresetProfile: Bool = false
    private let user: UserModel.User

    init (user: UserModel.User) {
        self.user = user
    }
    
    var body: some View {
        Button(action: {
            isPresetProfile.toggle()
        }) {
            HStack(alignment: .center, spacing: 0) {
                    if let avatar = self.user.avatar {
                        WebImage(url: URL(string: "\(API_URL)/uploads/\(avatar)")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44, height: 44)
                            .cornerRadius(10)
                            .padding(.trailing, 13)
                    } else {
                        UIDefaultAvatar(width: 44, height: 44, cornerRadius: 10)
                            .padding(.trailing, 13)
                    }
                
                VStack(alignment: .leading) {
                    Text(self.user.login ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#2E313C"))
                    Text(self.user.career ?? "")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#828796"))
                }
                Spacer(minLength: 0)
                Button(action: {
                    print("User hide")
                }) {
                    Image("circle.xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                }
            }
            
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 28)
        .buttonStyle(FlatLinkStyle())
//        .background(
//            NavigationLink(destination: ProfileView(userId:user.id).ignoreDefaultHeaderBar, isActive: $isPresetProfile) { EmptyView() }.frame(height: 0)
//                .opacity(0)
//        )
    }
}

struct UserSearchHistoryView : View {
    @EnvironmentObject var searchHistoryViewModel : SearchHistoryViewModel
  
    
    private var name : String
    
    init (name: String) {
        self.name = name
//        self._searchText = searchText
    }
    
    var body : some View {
        
        HStack(spacing: 0) {
            Button(action: {
//                if let searchText = self.searchText {
//                    searchText = self.name
//                }
            }) {
                HStack(spacing: 0) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.black.opacity(0.6))
                        .padding()
                        .background(
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.trailing, 13)
                    Text(self.name)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#2E313C"))
                }
            }
            Spacer(minLength: 0)
            Button(action: {
                searchHistoryViewModel.removeUserSearchedHistory(user: self.name)
            }) {
                Image("circle.xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
            }
        }
    }
}

private struct SearchLayer : View {
    @EnvironmentObject var searchViewModel : SearchViewModel
    @EnvironmentObject var searchHistoryViewModel : SearchHistoryViewModel
    @State private var animated : Bool = false
    @State private var selection: String = "Аккаунт"
    private let tabs: [String] = ["Аккаунт", "Медиа", "Посты"]
    
    var body : some View {
        ZStack(alignment: .top) {
            
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                self.tabsHeader()
                VStack {
                    TabView(selection: self.$selection) {
                        List {
                            if searchViewModel.searchText.count > 0 {
                                ForEach(0..<self.searchViewModel.users.count, id: \.self) {index in
                                    SearchUserItem(user: self.searchViewModel.users[index])
                                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                        .listRowBackground(Color.clear)
                                        .listRowSeparatorTint(.clear)
                                }
                            }
                            if searchViewModel.searchText.count == 0 {
                                if self.searchHistoryViewModel.usersSearchHistory.count > 0 {
                                    HStack(spacing: 0) {
                                        Text("Недавнее")
                                            .font(.custom(GothamBold, size: 16))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("Все")
                                            .font(.custom(GothamBook, size: 13))
                                            .foregroundColor(.blue)
                                            .overlay(NavigationLink(destination: RecentUserSearchQueries()
                                                                        .environmentObject(self.searchHistoryViewModel)
                                                                        .ignoreDefaultHeaderBar, label: {
                                                                    EmptyView()
                                            }).opacity(0))
                                    }
                                    .padding(.top)
                                    .padding(.horizontal, 15)
                                    .padding(.bottom, 30)
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .listRowBackground(Color.clear)
                                    .listRowSeparatorTint(.clear)
                                }
                                
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
                        .onAppear {
                            self.searchHistoryViewModel.getUsersSearchedHistory()
                        }
                        .tag("Аккаунт")
                        
                        List {
                            Text("Медиа")
                        }
                        .listStyle(.plain)
                        .tag("Медиа")
                        
                        List {
                            Text("Посты")
                        }
                        .listStyle(.plain)
                        .tag("Посты")
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: Alignment(horizontal: .leading, vertical: .top))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: Alignment(horizontal: .leading, vertical: .top))
            
        }
        .opacity(self.animated ? 1 : 0)
        .onAppear {
            withAnimation(.spring()) {
                animated = true
            }
        }
    }
    
    @ViewBuilder
    private func tabsHeader() -> some View {
        ZStack(alignment: .bottom) {
            
            Rectangle()
                .fill(Color(hex: "#DDE8E8"))
                .frame(height: 1)
                .offset(y: -1)
            
            HStack(spacing: 0) {
                ForEach(0..<self.tabs.count, id: \.self) {index in
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                        Button(action: {
                            withAnimation(.default) {
                                self.selection = self.tabs[index]
                            }
                        }) {
                            Text(self.tabs[index])
                                .font(.custom(self.selection == self.tabs[index] ? GothamBold : GothamBook, size: 12))
                                .textCase(.uppercase)
                                .foregroundColor(Color(hex: self.selection == self.tabs[index] ? "#5B86E5" :  "#333333"))
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / CGFloat(self.tabs.count) - 32))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "#5B86E5").opacity(self.selection == self.tabs[index] ? 1 : 0))
                            .frame(width: (UIScreen.main.bounds.width / CGFloat(self.tabs.count) - 32), height: 3)
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        }
    }
}

private struct SearchCompositionLayout<Content, Item, ID>  : View where Content: View, Item: RandomAccessCollection, Item.Element: Hashable , ID: Hashable {
    
    private let content: (Item.Element) ->  Content
    private let id: KeyPath<Item.Element, ID>
    private let items: Item
    private let spacing: CGFloat
     
    init (items: Item, id: KeyPath<Item.Element, ID>, spacing: CGFloat = 5, @ViewBuilder content: @escaping (Item.Element) -> Content ) {
        self.items = items
        self.id = id
        self.content = content
        self.spacing = spacing
    }
    
    var body : some View {
        LazyVStack(spacing: self.spacing ) {
            ForEach(self.generateColumns(), id: \.self) {row in
                
                self.RowView(row: row)
            }
        }
    }
    
    private func layoutType (row: [Item.Element]) -> LayoutType {
        
        let index = self.generateColumns().firstIndex { item in
            return item == row
        } ?? 0
        
        var types: [LayoutType] = []
        
        self.generateColumns().forEach {_ in
            if types.isEmpty {
                
                types.append(.type1)
            } else if types.last == .type1 {
                
                types.append(.type2)
            } else if types.last == .type2 {
                 
                types.append(.type3)
            } else if types.last == .type3 {
                
                types.append(.type1)
            } else { }
        }
        
        return types[index ]
    }
    
    @ViewBuilder
    private func RowView (row: [Item.Element ]) -> some View {
        
        GeometryReader {proxy in
            
            let width = proxy.size.width
            let height = (proxy.size.height - spacing) / 2
            let type = self.layoutType(row: row)
            let columnWidth = (width > 0 ? ((width - (spacing * 2 )) / 3 ) : 0)
            
            HStack(spacing: self.spacing) {
                if type == .type1 {
                    self.SafeView(row: row, index: 0)
                    VStack(spacing: self.spacing) {
                        self.SafeView(row: row, index: 1)
                            .frame(height: height)
                        self.SafeView(row: row, index: 2)
                            .frame(height: height)
                    }
                    .frame(width: columnWidth)
                }
                
                if type == .type2 {
                    HStack(spacing: self.spacing) {
                        self.SafeView(row: row, index: 2)
                            .frame(width: columnWidth)
                        self.SafeView(row: row, index: 1)
                            .frame(width: columnWidth)
                        self.SafeView(row: row, index: 0)
                            .frame(width: columnWidth)
                    }
                }
                
                if type == .type3 {
                    VStack(spacing: self.spacing) {
                        self.SafeView(row: row, index: 0)
                            .frame(height: height)
                        self.SafeView(row: row, index: 1)
                            .frame(height: height)
                    }
                    .frame(width: columnWidth)
                    self.SafeView(row: row, index: 2 )
                }
            }
        }
        .frame(height: self.layoutType(row: row) ==  .type1 || self.layoutType(row: row) ==  .type3 ? 250 : 120 )
    }
    
    @ViewBuilder
    private func SafeView(row: [Item.Element], index: Int) -> some View {
        
        if (row.count -  1) >= index {
            content(row[index ])
        }
    }
    
    private func generateColumns() -> [[Item.Element]] {
        var columns: [[Item.Element]] = []
        var row: [Item.Element] = []
        
        for item in items {
            
            if row.count == 3 {
                columns.append(row)
                row.removeAll()
                row.append(item )
            } else {
                row.append(item)
            }
        }
        
        columns.append(row)
        row.removeAll()
        return columns
    }
}

enum LayoutType {
    case type1
    case type2
    case type3
}
