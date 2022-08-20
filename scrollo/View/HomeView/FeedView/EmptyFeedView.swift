//
//  EmptyFeedView.swift
//  scrollo
//
//  Created by Artem Strelnik on 20.08.2022.
//

import SwiftUI

struct EmptyFeedView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Добро пожаловать в Scrollo!")
                .fontWeight(.semibold)
                .foregroundColor(Color.black)
                .padding(.bottom, 5)
            Text("Здесь будут показываться фото и видео людей, на которых вы подпишитесь.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.horizontal, 40)
        }
    }
}

struct EmptyFeedView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFeedView()
    }
}
