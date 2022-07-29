//
//  StickyHeader.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct StickyHeader: View {
    var background: String?
    let height: CGFloat = 150
    
    var body: some View {
        GeometryReader{reader in
            let minY = reader.frame(in: .global).minY
            if let background = background {
                AnimatedImage(url: URL(string: "\(API_URL)/uploads/\(background)")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: minY > 0 ? minY + height : height)
                    .background(Color(hex: "#f7f7f7"))
                    .offset(y: -minY)
            } else {
                
                LinearGradient(colors: [
                    Color(hex: "#5B86E5"),
                    Color(hex: "#36DCD8")
                ], startPoint: .trailing, endPoint: .leading)
                    .frame(width: UIScreen.main.bounds.width, height: minY > 0 ? minY + height : height)
                    .offset(y: -minY)
            }
            
        }
        .frame(height: height)
    }
}

struct StickyHeader_Previews: PreviewProvider {
    static var previews: some View {
        StickyHeader()
    }
}
