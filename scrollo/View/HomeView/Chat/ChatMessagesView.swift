//
//  ChatMessagesView.swift
//  scrollo
//
//  Created by Artem Strelnik on 14.09.2022.
//

import SwiftUI

struct ChatMessagesView: View {
    @StateObject var messageViewModel: MessageViewModel = MessageViewModel()
    @ObservedObject var player: AudioPlayer = AudioPlayer()
    
    @State var isPresentSelectAttachments: Bool = false
    @State var isVoiceRecord: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            HeaderBar()
            
            ScrollView(showsIndicators: false) {
                ScrollViewReader{scrollReader in
                    VStack(spacing: 16) {
                        DetailUserView()
                            .padding(.bottom, messageViewModel.messages.count == 0 ? 300 : 0)
                        Spacer()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight:0, maxHeight: .infinity, alignment: Alignment.topLeading)
                        ForEach(0..<messageViewModel.messages.count, id: \.self){index in
                            if messageViewModel.messages[index].content != nil {
                                TextMessageView(message: $messageViewModel.messages[index])
                            }
                            else if messageViewModel.messages[index].audio != nil {
                                AudioMessageView(message: $messageViewModel.messages[index])
                                    .environmentObject(player)
                            }
                        }
                        .onChange(of: messageViewModel.messages) { (value) in
                            scrollReader.scrollTo(value.last?.id)
                        }
                    }
                    .padding()
                    .rotationEffect(Angle(degrees: 180))
                }
            }
            .rotationEffect(Angle(degrees: 180))
            
            Spacer(minLength: 0)
            
            VStack(spacing: 0) {
                
                HStack(spacing: 0) {
                    
                    TextField("Написать сообщение...", text: $messageViewModel.message)
                    
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
                        UIApplication.shared.endEditing()
                        isPresentSelectAttachments.toggle()
                    }) {
                        Image("image")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.trailing, 8)
                    

                    Button(action: {
                        if !messageViewModel.message.isEmpty{
                            withAnimation(.easeInOut){
                                messageViewModel.sendMessage(message: MessageModel(type: "STARTER", content: messageViewModel.message))
                                
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut){
                                    messageViewModel.sendMessage(message: MessageModel(type: "RECIVER", content: "MatreshkaVPN безотказный и простой в использовании анонимайзер позволяющий вам посещать любые сайты и приложения, на которые наложены ограничения провайдером, оставаясь полностью анонимным. Matreshka не просто подменяет локацию вашего устройства, но и передает все ваши запросы в зашифрованном виде, переводя устройство в режим “невидимки”. Высокая скорость соединения, неограниченный трафик и различное расположение сервером обеспечат вам комфортное использование любых сайтов и приложений. MatreshkaVPN не мешает работе остальных приложений и не снижает скорость вашего интернета."))
                                
                                    messageViewModel.sendMessage(message: MessageModel(type: "RECIVER", audio: URL(string: "https://zvukogram.com/index.php?r=site/download&id=43127")))
                                    
                                    messageViewModel.sendMessage(message: MessageModel(type: "RECIVER", audio: URL(string: "https://zvukogram.com/index.php?r=site/download&id=43101")))
                                    
                                    messageViewModel.sendMessage(message: MessageModel(type: "RECIVER", audio: URL(string: "https://zvukogram.com/index.php?r=site/download&id=43103")))
                                    
                                    messageViewModel.sendMessage(message: MessageModel(type: "RECIVER", audio: URL(string: "https://zvukogram.com/index.php?r=site/download&id=78804")))
                                    
                                
                                
                                }
                            }
                            messageViewModel.message = String()
                        }
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
                    VoiceRecorderView(isVoiceRecord: $isVoiceRecord, onSendAudio: {audio in
                        print("send audio: \(audio)")
                        messageViewModel.sendMessage(message: MessageModel(type: "STARTER", audio:audio))
                        isVoiceRecord.toggle()
                    })
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

private struct HeaderBar: View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View{
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
    }
}
