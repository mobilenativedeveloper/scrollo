//
//  PostCompositionView.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

struct PostCompositionView: View {
    @Binding var posts: [[[PostModel]]]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<posts.count, id: \.self) {index in
                CompositionStack(stack: $posts[index])
            }
        }
    }
}

//struct PostCompositionView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostCompositionView()
//    }
//}
