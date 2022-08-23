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
    @State var selectedStories: [Int] = []
    private let columns = 3
    private let size = (UIScreen.main.bounds.width / 3) - 12
    
    let countStories = 31
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
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
                    Text(selectedStories.count > 0 ? "Выбрано: \(selectedStories.count)" : "Истории")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .foregroundColor(Color(hex: "#2E313C"))
                    Spacer(minLength: 0)
                    NavigationLink(destination: ActualStoryCoverView().ignoreDefaultHeaderBar) {
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
            .ignoreDefaultHeaderBar
        }
    }
    
    private func makeGrid() -> some View {
        let count = countStories
        let rows = count / columns + (count % columns == 0 ? 0 : 1)
            
        return VStack(alignment: .leading, spacing: 9) {
            ForEach(0..<rows) { row in
                HStack(spacing: 9) {
                    ForEach(0..<self.columns) {column in
                        let index = row * self.columns + column
                        if index < count {
                            Button(action: {
                                if let index = selectedStories.firstIndex(where: {$0 == index}) {
                                    selectedStories.remove(at: index)
                                } else {
                                    
                                    selectedStories.append(index)
                                }
                            }) {
                                StoryCardPreviewView(selectedStories: $selectedStories, image: "https://picsum.photos/200/300?random=\(index)", index: index, size: size)
                            }
                            .buttonStyle(FlatLinkStyle())
                        } else {
                            AnyView(EmptyView())
                                .frame(width: size, height: 180)
                        }
                    }
                }
            }
        }
        .padding(.top, 10)
    }
}


private struct StoryCardPreviewView: View {
    @Binding var selectedStories: [Int]
    var image: String
    var index: Int
    var size: CGFloat
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack(alignment: .topTrailing) {
                WebImage(url: URL(string: image)!)
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
                    .fill(Color.black)
                    .frame(width: 38, height: 38)
                    .overlay(
                        VStack(spacing: 0){
                            Text("\(index + 1)")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Text("марта")
                                .font(.system(size: 9))
                                .foregroundColor(.white)
                        }
                    )
                    .offset(x: 10, y: 10)
            }
        }
    }
    
    func getNumber () -> Int {
        
        if let i = selectedStories.firstIndex(where: { $0 == index}) {
            
            return i + 1
        } else {
            
            return -1
        }
    }
    func checkSelect () -> Bool {
        
        if let _ = selectedStories.firstIndex(where: { $0 == index}) {
            
            return true
        } else {
            
            return false
        }
    }
}
