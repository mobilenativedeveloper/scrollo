//
//  UIViewStoriesList.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI

struct StoriesListView : View {
    @EnvironmentObject var storyData: StoryViewModel
    
    var body : some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 0) {
                StoriesUserListItem()
                    .padding(.leading)
                
                ForEach(0..<storyData.stories.count){index in
                    StoriesListItem(story: storyData.stories[index])
                        .padding(.leading, 10)
                }
            }
        }
    }
    
    @ViewBuilder
    func StoriesUserListItem () -> some View {
        VStack {
            Image("Plus")
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(width: 62, height: 62)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 1,dash: [6])
                        )
                        .frame(width: 53, height: 53)
                        .foregroundColor(Color(hex: "#828282"))
                )
                .background(
                    Color.white
                        .frame(width: 65, height: 65)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                )
                .background(
                    Color(hex: "#828282")
                        .frame(width: 68, height: 68)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                )
            Text("Вы")
                .font(Font.custom(GothamMedium, size: 12))
                .foregroundColor(Color(hex: "4F4F4F"))
                .frame(width: 70)
                .lineLimit(1)
                .fixedSize()
        }
        .frame(width: 70, height: 96)
    }
    
    @ViewBuilder
    func StoriesListItem (story: StoryModel) -> some View {
        VStack {
            Image(story.profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 62, height: 62)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .background(
                    Color.white
                        .frame(width: 65, height: 65)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                )
                .background(self.isSeen(seen: story.isSeen))
            Text(story.profileName)
                .font(Font.custom(GothamMedium, size: 12))
                .foregroundColor(Color(hex: "4F4F4F"))
                .frame(width: 70)
                .lineLimit(1)
                .fixedSize()
        }
        .frame(width: 70, height: 96)
        .onTapGesture {
            withAnimation {
                storyData.currentStory = story.id
                storyData.showStory = true
            }
        }
    }
    
    @ViewBuilder
    func isSeen (seen: Bool) -> some View {
        if !seen {
            LinearGradient(gradient: Gradient(colors: [
                Color(hex: "#36DCD8"),
                Color(hex: "#5B86E5")
            ]), startPoint: .leading, endPoint: .trailing)
                .frame(width: 68, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        } else {
            Color(hex: "#E0E0E0")
                .frame(width: 68, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

struct StoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        StoriesListView()
    }
}
