//
//  CompositionColumn.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

struct CompositionColumn: View {
    @Binding var posts: [PostModel]
    var columnIndex: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(0..<posts.count, id: \.self) {index in
                UIPostCompositionView(post: $posts[index], index: index, columnIndex: columnIndex)
            }
        }
    }
}

//struct CompositionColumn_Previews: PreviewProvider {
//    static var previews: some View {
//        CompositionColumn()
//    }
//}
