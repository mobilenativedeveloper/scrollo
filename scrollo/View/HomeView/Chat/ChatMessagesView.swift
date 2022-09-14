//
//  ChatMessagesView.swift
//  scrollo
//
//  Created by Artem Strelnik on 14.09.2022.
//

import SwiftUI

struct ChatMessagesView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var message : String = String()
    
    @State var isPresentSelectAttachments: Bool = false
    @State var isVoiceRecord: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("circle.left.arrow")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fill)
                }
                .padding(.trailing, 10)
                HStack(spacing: 8) {
                    Image("testUserPhoto")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .cornerRadius(8)
                        .padding(.trailing, 5)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Max Jacobson")
                            .font(.custom(GothamBold, size: 14))
                            .foregroundColor(Color(hex: "#444A5E"))
                        Text("jacobs_max")
                            .font(.custom(GothamBook, size: 12))
                            .foregroundColor(Color(hex: "#828796"))
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            GeometryReader{geometry in
                ScrollView(showsIndicators: false) {
                    VStack{
                        DetailUser()
                        
                        Spacer(minLength: 0)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight:0, maxHeight: .infinity, alignment: Alignment.topLeading)
                        
                        VStack{
                            Spacer(minLength: 0)
                            UIFromMessage()
                            WaveformView()
                            UIToMessage()
                        }
                        .padding(.horizontal)
                    }
                    
                    .frame(minHeight: geometry.size.height)
                }
                .frame(width: geometry.size.width)

            }
            
            Spacer(minLength: 0)
            
            VStack(spacing: 0) {
                
                HStack(spacing: 0) {
                    
                    TextField("Написать сообщение...", text: self.$message)
                    
                    Button(action: {
                        withAnimation(.easeInOut){
                            isVoiceRecord.toggle()
                        }
                    }) {
                        Image("microphone")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.trailing, 8)
                    
                    Button(action: {
                        isPresentSelectAttachments.toggle()
                    }) {
                        Image("image")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.trailing, 8)
                    

                    Button(action: {
                        
                    }) {
                        Image("send")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.horizontal)
                .frame(height: 42)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "#DDE8E8"), lineWidth: 1)
                )
                .overlay(
                    VoiceRecordView(isVoiceRecord: $isVoiceRecord)
                )
            }
            .padding()
            .background(Color.white)
            .overlay(
                Color(hex: "#F2F2F2")
                    .frame(height: 1)
                ,alignment: .top
            )
            .shadow(color: Color(hex: "#1e5385").opacity(0.03), radius: 10, x: 0, y: -12)
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .overlay(SelectAttachmentsView(isPresent: $isPresentSelectAttachments))
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

private struct DetailUser: View {
    var body: some View{
        VStack(spacing: 0){
            Image("testUserPhoto")
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .padding(.bottom, 6)
            Text("Name Lastname")
                .font(.system(size: 14))
                .fontWeight(.bold)
                .padding(.bottom, 3)
            Text("login • Scrollo")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#838383"))
                .padding(.bottom, 1)
            Text("Подписчики: 135 • Публикации: 0")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#838383"))
                .padding(.bottom, 8)
            NavigationLink(destination: Text("Profile").ignoreDefaultHeaderBar){
                Text("Посмотреть профиль")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 13)
                    .background(Color(hex: "#efefef").cornerRadius(8))
            }
        }
    }
}

private struct SelectAttachmentsView: View{
    @Binding var isPresent: Bool
    @State var offset: CGFloat = 900
    @State var opacity: CGFloat = 0
    let height: CGFloat = 700
    let bounceOffset: CGFloat = 200
    var body: some View{
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

private struct UIFromMessage : View {
    
    var body : some View {
        
        HStack(spacing: 0) {
            Spacer()
            Text("While more and more services and products are evolving into digital products.How to represent a brand in your UI becomes a")
                .font(.custom(GothamBook, size: 12))
                .foregroundColor(.white)
                .padding(.all, 11)
                .frame(maxWidth: UIScreen.main.bounds.width - 100)
                .background(Color(hex: "#5B86E5"))
                .clipShape(CustomCorner(radius: 10, corners: [.topLeft, .bottomLeft, .bottomRight]))
        }
        .padding(.vertical, 8)
    }
}

private struct UIToMessage : View {
    
    var body : some View {
        
        HStack(spacing: 0) {
            Image("testUserPhoto")
                .resizable()
                .scaledToFill()
                .frame(width: 34, height: 34)
                .cornerRadius(8)
                .clipped()
                .padding(.trailing, 17)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "F2F2F2"), lineWidth: 1)
                HStack(spacing: 0) {
                    
                    Text("Trying to make lemonade out of lemons -my homegirl Shania and I did an ‘at home’.")
                        .font(.custom(GothamBook, size: 12))
                        .foregroundColor(Color(hex: "2E313C"))
                        .frame(maxWidth: UIScreen.main.bounds.width - 100)
                }
                .padding(.all, 11)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .frame(maxWidth: UIScreen.main.bounds.width - 50)
    }
}

private struct WaveformView: View {
    let waveformPixelsPerWindow = Int(3000 / UIScreen.main.bounds.width)
    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: 2.0) {
                Image(systemName: "play.circle")
                    .foregroundColor(Color(hex: "#6F83E9"))
                    .padding(.trailing, 16)
                    .font(.title)
                ForEach(0..<20, id: \.self){index in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "#5B86E5"))
                        .frame(width: 5, height: self.getRandomHeight())
                }
                Text("00:59")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#5B86E5"))
                    .padding(.leading, 16)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color(hex: "#5B86E5").opacity(0.15))
            .cornerRadius(10)
        }
    }
    
    func getRandomHeight () -> CGFloat {
        let randomDouble = Double.random(in: 3.0...50.0)
        return randomDouble
    }
}
