//
//  CompositionStack.swift
//  scrollo
//
//  Created by Artem Strelnik on 29.07.2022.
//

import SwiftUI

struct CompositionStack: View {
    @Binding var stack: [[PostModel]]
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ForEach(0..<stack.count, id: \.self) {index in
                CompositionColumn(posts: $stack[index], columnIndex: index)
            }
        }
    }
}
