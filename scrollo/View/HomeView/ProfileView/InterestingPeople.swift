//
//  InterestingPeople.swift
//  scrollo
//
//  Created by Artem Strelnik on 30.07.2022.
//

import SwiftUI

struct InterestingPeople: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("circle_close")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
                Spacer(minLength: 0)
                Text("Интересные люди")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(Color(hex: "#1F2128"))
                Spacer(minLength: 0)
                Button(action: {
                   
                }) {
                    Color.clear
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.bottom)
            .padding(.horizontal)
            Spacer()
            VStack {
                ScrollView {
                    ForEach(0..<15, id: \.self) {index in
                        InterestingUserView()
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    
}

struct InterestingUserView : View {
    var body : some View {
        HStack(alignment: .center, spacing: 0) {
            Image("story1")
                .resizable()
                .frame(width: 44, height: 44)
                .cornerRadius(10)
                .padding(.trailing, 16)
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                Text("diana_slown")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                Text("UI/UX designer")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#828796"))
                Spacer()
            }
            Spacer()
            Button(action: {}) {
                Text("Подписаться")
                    .font(.system(size: 11))
                    .foregroundColor(.white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 9)
                    .background(Color(hex: "#5B86E5"))
                    .cornerRadius(6)
            }
            .padding(.trailing)
            Button(action: {}) {
                Image("circle_close")
                    .resizable()
                    .frame(width: 22, height: 22)
            }
        }
        .padding(.top, 5)
        .padding(.bottom, 10)
        .padding(.horizontal)
    }
}

struct InterestingPeople_Previews: PreviewProvider {
    static var previews: some View {
        InterestingPeople()
    }
}
