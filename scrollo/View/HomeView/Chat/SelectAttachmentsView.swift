//
//  SelectAttachmentsView.swift
//  scrollo
//
//  Created by Artem Strelnik on 15.09.2022.
//

import SwiftUI

struct SelectAttachmentsView: View {
    
    @Binding var isPresent: Bool
    @State var offset: CGFloat = 900
    @State var opacity: CGFloat = 0
    let height: CGFloat = 700
    let bounceOffset: CGFloat = 200
    
    var body: some View {
        if isPresent {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
                Color.black.opacity(opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            self.opacity = 0
                            self.offset = 900
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isPresent = false
                            }
                        }
                    }
                GeometryReader{reader in
                    VStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(hex: "F2F2F2"))
                            .frame(width: 40, height: 4)
                            .padding(.top)
                            .padding(.bottom, 25)
                        
                        Text("Получите доступ к своим фото и видео из Scrollo")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .frame(width: 300)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 40)
                        
                        HStack(alignment: .top){
                            Image(systemName: "info.circle")
                                .font(.title)
                                .frame(width: 30, height: 30)
                            Text("Вы сможете получить доступ ко всем своим фото из Scrollo или выбрать несколько из них вручную.")
                                .font(.system(size: 13))
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .frame(width: 350)
                        .padding(.bottom)
                        HStack(alignment: .top){
                            Image(systemName: "checkmark.shield")
                                .font(.title)
                                .frame(width: 30, height: 30)
                            Text("Вы сами решаете, какими фото и видео делиться с другими.")
                                .font(.system(size: 13))
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .frame(width: 350)
                        .padding(.bottom)
                        HStack(alignment: .top){
                            Image(systemName: "photo")
                                .font(.system(size: 14))
                                .frame(width: 30, height: 30)
                            Text("Делиться контентом в Scrollo проще, когда у вас есть доступ ко всей фотопленке.")
                                .font(.system(size: 13))
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .frame(width: 350)
                        .padding(.bottom)
                        
                        Text("Выберите Разрешить доступ ко всем фото, чтобы открыть вашу фотопленку из приложения Scrollo.")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .frame(width: 290)
                            .multilineTextAlignment(.center)
                    
                    }
                    .frame(width: reader.size.width)
                }
                .frame(height: height + bounceOffset)
                .background(Color.white)
                .clipShape(CustomCorner(radius: 20, corners: [.topLeft, .topRight]))
                .overlay(
                    HStack{
                        Button(action: {}) {
                            Text("Продолжить")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40)
                        .background(Color(hex: "#5B86E5").clipShape(RoundedRectangle(cornerRadius: 10)))
                    }
                        .background(Color.white)
                        .offset(y: -(bounceOffset + 100))
                    ,alignment: .bottom
                )
                .offset(y: offset + bounceOffset)
                .gesture(DragGesture().onChanged(onChange(value: )).onEnded(onEnd(value:)))
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear{
                withAnimation(.easeInOut){
                    self.opacity = 0.5
                    self.offset = .zero
                }
            }
        } else {
            Color.clear.frame(height: 0)
        }
    }
    
    func onChange(value: DragGesture.Value) {
        
        if !(value.translation.height < -(bounceOffset / 2)) {
            self.offset = value.translation.height
        }
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(.easeInOut) {
            if value.translation.height > ((height + bounceOffset) / 3) {
                self.offset = height + bounceOffset
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.opacity = 0
                    self.offset = 900
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPresent = false
                    }
                }
            }
            else if (value.translation.height < (offset + bounceOffset)) {
                self.offset = 0
            }
            else {
                self.offset = 0
            }
        }
    }
}
