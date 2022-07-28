//
//  TruncateTextView.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI

struct TruncateTextView: View {
    @State private var fullPost: Bool = false
    var text: String
    let limitedTextLength: Int = 140
    
    var body: some View {
        if self.text.count > self.limitedTextLength {
            let index = self.text.index(self.text.startIndex, offsetBy: self.limitedTextLength)
            VStack(alignment: .leading) {
                if self.fullPost {
                    textWithHashtags(self.text, color: Color(hex: "#5B86E5"))
                        .font(Font.custom(GothamBook, size: 14))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                } else {
                    Group {
                        textWithHashtags(String(self.text.prefix(upTo: index)), color: Color(hex: "#5B86E5")) + Text("...") + Text(" ") + Text("Развернуть").foregroundColor(.blue)
                    }
                    .font(Font.custom(GothamBook, size: 14))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                }
            }
            .onTapGesture(perform: {
                withAnimation(.default) {
                    self.fullPost = true
                }
            })
        } else {
            textWithHashtags(self.text, color: Color(hex: "#5B86E5"))
                .font(Font.custom(GothamBook, size: 14))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
        }
    }
}

//struct TruncateTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        TruncateTextView()
//    }
//}
