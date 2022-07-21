//
//  UIDefaultAvatar.swift
//  scrollo
//
//  Created by Artem Strelnik on 03.07.2022.
//

import SwiftUI

struct UIDefaultAvatar: View {
    
    let width : CGFloat
    let height : CGFloat
    let background : Color
    let cornerRadius : CGFloat
    
    init (width: CGFloat, height: CGFloat, cornerRadius: CGFloat, background: Color = Color.white) {
        self.width = width
        self.height = height
        self.background = background
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        VStack {
            Image("default_avatar")
                .resizable()
                .scaledToFill()
                .frame(width: self.width, height: self.height)
        }
        .frame(width: self.width, height: self.height)
        .background(self.background)
        .cornerRadius(self.cornerRadius)
    }
}

//struct UIDefaultAvatar_Previews: PreviewProvider {
//    static var previews: some View {
//        UIDefaultAvatar()
//    }
//}
