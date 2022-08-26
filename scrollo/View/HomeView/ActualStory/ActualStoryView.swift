//
//  ActualStory.swift
//  scrollo
//
//  Created by Artem Strelnik on 21.08.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActualStoryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var actualStoryViewModel: ActualStoryViewModel = ActualStoryViewModel()
    @State var actualStoryCoverView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("circle_close")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .aspectRatio(contentMode: .fill)
                    }
                    Spacer(minLength: 0)
                    Text(actualStoryViewModel.selectedStories.count > 0 ? "Выбрано: \(actualStoryViewModel.selectedStories.count)" : "Истории")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .foregroundColor(Color(hex: "#2E313C"))
                    Spacer(minLength: 0)
                    Button(action: {
                        if actualStoryViewModel.selectedStories.count > 0 {
                            actualStoryCoverView.toggle()
                        }
                    }) {
                        Image("circle.right.arrow")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .padding(.horizontal, 23)
                .padding(.bottom)
                
                ScrollView(showsIndicators: false) {
                    makeGrid()
                }
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(
                NavigationLink(destination: ActualStoryCoverView(
                    covers: actualStoryViewModel.actualStories
                ).ignoreDefaultHeaderBar, isActive: $actualStoryCoverView, label: {
                    EmptyView()
                }).hidden()
            )
            .ignoreDefaultHeaderBar
        }
    }
    
    private func makeGrid() -> some View {
        let count = actualStoryViewModel.actualStories.count
        let rows = count / actualStoryViewModel.columns + (count % actualStoryViewModel.columns == 0 ? 0 : 1)
            
        return VStack(alignment: .leading, spacing: 9) {
            ForEach(0..<rows) { row in
                HStack(spacing: 9) {
                    ForEach(0..<actualStoryViewModel.columns) {column in
                        let index = row * actualStoryViewModel.columns + column
                        if index < count {
                            Button(action: {
                                if let index = actualStoryViewModel.selectedStories.firstIndex(where: {$0.id == actualStoryViewModel.actualStories[index].id}) {
                                    actualStoryViewModel.selectedStories.remove(at: index)
                                } else {
                                    actualStoryViewModel.selectedStories.append(actualStoryViewModel.actualStories[index])
                                }
                            }) {
                                StoryCardPreviewView(selectedStories: actualStoryViewModel.selectedStories, story: actualStoryViewModel.actualStories[index], index: index, size: actualStoryViewModel.size)
                            }
                            .buttonStyle(FlatLinkStyle())
                        } else {
                            AnyView(EmptyView())
                                .frame(width: actualStoryViewModel.size, height: 180)
                        }
                    }
                }
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 9)
    }
}


private struct StoryCardPreviewView: View {
    var selectedStories: [ActualStoryModel]
    var story: ActualStoryModel
    var index: Int
    var size: CGFloat
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack(alignment: .topTrailing) {
                WebImage(url: URL(string: story.url)!)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .frame(width: size, height: 180)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .clipped()
                    .overlay(
                        Color.white.opacity(self.checkSelect() ? 0.4 : 0)
                    )
                
                let number = self.getNumber()
                
                ZStack {
                    Circle()
                        .strokeBorder(Color.white,lineWidth: 1)
                        .background(Circle().foregroundColor(self.checkSelect() ? Color(hex: "#66b0ff") : Color.white.opacity(0.3)))
                        .frame(width: 20, height: 20)
                    if number != -1 {
                        Text("\(number)")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                        
                }
                .frame(width: 20, height: 20)
                .offset(x: -7, y: 7)
                
            }
            if (index + 4) % 2 == 0  || index == 0{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 38, height: 38)
                    .overlay(
                        VStack(spacing: 0){
                            Text("\(index + 1)")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            Text("марта")
                                .font(.system(size: 9))
                                .foregroundColor(.black)
                        }
                    )
                    .offset(x: 10, y: 10)
            }
        }
    }
    
    func getNumber () -> Int {
        
        if let i = selectedStories.firstIndex(where: { $0.id == story.id}) {
            
            return i + 1
        } else {
            
            return -1
        }
    }
    func checkSelect () -> Bool {
        
        if let _ = selectedStories.firstIndex(where: { $0.id == story.id}) {
            
            return true
        } else {
            
            return false
        }
    }
}

struct ActualStoryModel {
    var id = UUID().uuidString
    var url: String
}

class ActualStoryViewModel: ObservableObject {
    @Published var selectedStories: [ActualStoryModel] = []
    let actualStories: [ActualStoryModel] = [
        ActualStoryModel(url: "https://images.unsplash.com/photo-1660570153201-adf2c9b87a72?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"),
        ActualStoryModel(url: "https://images.unsplash.com/photo-1660554969989-99b47174f499?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80")
    ]
    let columns = 3
    let size = (UIScreen.main.bounds.width / 3) - 12
}
