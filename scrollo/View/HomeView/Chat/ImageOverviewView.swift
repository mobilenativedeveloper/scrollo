//
//  ImageOverviewView.swift
//  scrollo
//
//  Created by Artem Strelnik on 16.09.2022.
//

import SwiftUI

struct ImageOverviewView: View {
    @Binding var loadExpandedContent: Bool
    @Binding var isExpanded: Bool
    @Binding var expandedMedia: MessageModel?
    var animation: Namespace.ID
    
    var body: some View {
        if let expandedMedia = self.expandedMedia{
            VStack{
                GeometryReader{proxy in
                    let size = proxy.size
                    if let thumbnail = expandedMedia.asset?.thumbnail {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .cornerRadius(loadExpandedContent ? 0 : 10)
                    }
                }
                .matchedGeometryEffect(id: expandedMedia.id, in: animation)
                .frame(height: 300)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .top, content:{
                HStack(spacing: 10){
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)){
                            loadExpandedContent = false
                        }
                        withAnimation(.easeInOut(duration: 0.4).delay(0.05)){
                            isExpanded = false
                            self.expandedMedia = nil
                        }
                    }){
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    Spacer(minLength: 10)
                }
                .padding()
                .opacity(loadExpandedContent ? 1 : 0)
            })
            .transition(.offset(x: 0, y: 1))
            .onAppear{
                withAnimation(.easeInOut(duration: 0.4)){
                    loadExpandedContent = true
                }
            }
        }
    }
}
