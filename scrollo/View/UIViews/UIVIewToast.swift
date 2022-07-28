//
//  UIVIewToast.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI

extension View {
    func toast<Content: View>(isPresent: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            self
            UIVIewToast(isPresent: isPresent) {
                content()
            }
        }
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .top
            )
    }
}

enum ToastAnimation { case initial, present, dismiss}

struct UIVIewToast<Content: View>: View {
    @State var animation: ToastAnimation = .initial
    @Binding var isPresent: Bool
    let content: Content
    let width = UIScreen.main.bounds.width - 40
    
    init (isPresent: Binding<Bool>, content: () -> Content) {
        self._isPresent = isPresent
        self.content = content()
    }
    
    var body : some View {
        
        if isPresent {
            GeometryReader{reader in
                VStack {
                    Spacer()
                    HStack(spacing: 0) {
                        self.content
                            .padding(.horizontal)
                    }
                    Spacer()
                }
            }
            .frame(maxHeight: 60)
            .cornerRadius(6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.7), radius: 2, x: 0, y: 0)
            )
            .padding(.horizontal)
            .offset(y: self.animation == .initial ? -300 : 0)
            .onAppear {
                withAnimation {
                    self.animation = .present
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                    withAnimation {
                        self.animation = .initial
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        isPresent = false
                    })
                })
            }
        } else {
            Color.clear.frame(height: 0)
        }
        
    }
}
