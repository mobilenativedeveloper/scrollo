//
//  AddPublicationSheet.swift
//  scrollo
//
//  Created by Artem Strelnik on 20.08.2022.
//

import SwiftUI

struct AddPublicationSheet: View {
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white
            
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("Добавить")
                            .font(.custom(GothamBold, size: 20))
                            .foregroundColor(Color(hex: "#2E313C"))
                            .textCase(.uppercase)
                        Spacer(minLength: 0)
                        Button(action: {}) {
                            Image("roundedRectanglePlus")
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 34)
                    Sepparator()
                    AddPublicationItem(icon: "publication", title: "публикацию")
                    Sepparator()
                    AddPublicationItem(icon: "post", title: "пост")
                    Sepparator()
                    AddPublicationItem(icon: "story", title: "историю")
                    Sepparator()
                    AddPublicationItem(icon: "actualStory", title: "актуальное из истории")
                    Sepparator()
                }
            }
            .padding(.top, 20)
        }
        .cornerRadius(25)
        .ignoresSafeArea()
    }
}

private struct AddPublicationItem: View {
    var icon: String
    var title: String
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 0) {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 23, height: 23)
                    .padding(.trailing, 14)
                Text(title)                     .font(.custom(GothamBook, size: 16))
                    .textCase(.uppercase)
                    .foregroundColor(.black)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
        }
    }
}

private struct Sepparator: View {
    let sepparatorGradient: LinearGradient = LinearGradient(colors: [Color(hex: "#C4C4C4").opacity(0), Color(hex: "#C4C4C4"), Color(hex: "#C4C4C4").opacity(0)], startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        Rectangle()
            .fill(sepparatorGradient)
            .frame(height: 1)
    }
}
