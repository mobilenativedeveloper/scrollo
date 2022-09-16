//
//  ImageMessageView.swift
//  scrollo
//
//  Created by Artem Strelnik on 16.09.2022.
//

import SwiftUI

struct ImageMessageView: View {
    @Binding var message: MessageModel
    var animation: Namespace.ID
    @Binding var isExpanded: Bool
    @Binding var expandedMedia: MessageModel?
    var body: some View {
        HStack(alignment: .top, spacing: 10){
            if message.type == "STARTER" {
                Spacer(minLength: 25)
                
                Image("story1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 150, height: 150)
//                    .clipped()
                    .matchedGeometryEffect(id: message.id, in: animation)
                    .clipShape(CustomCorner(radius: 10, corners: [.topLeft, .bottomLeft, .bottomRight]))
                    .opacity((expandedMedia?.id == message.id && isExpanded) ? 0 : 1)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)){
                            expandedMedia = message
                            isExpanded.toggle()
                        }
                    }
                
//                if expandedMedia?.id == message.id && isExpanded{
//                    Image("story1")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: UIScreen.main.bounds.width - 150, height: 150)
//                        .clipped()
//                        .cornerRadius(0)
//                        .opacity(0)
//                } else {
//                    Image("story1")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: UIScreen.main.bounds.width - 150, height: 150)
//                        .clipped()
//                        .matchedGeometryEffect(id: message.id, in: animation)
//                        .clipShape(CustomCorner(radius: 10, corners: [.topLeft, .bottomLeft, .bottomRight]))
//                        .onTapGesture {
//                            withAnimation(.easeInOut(duration: 0.3)){
//                                expandedMedia = message
//                                isExpanded.toggle()
//                            }
//                        }
//                }
                
            }
            else {
                Image("testUserPhoto")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 34, height: 34)
                    .cornerRadius(8)
                    .clipped()
                Image("story1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 150, height: 150)
                    .clipped()
                    .allowsHitTesting(false)
                    .background(Color(hex: "#F2F2F2"))
                    .cornerRadius(12)
                Spacer(minLength: 25)
            }
        }
        .padding(.vertical)
        .id(message.id)
    }
}
