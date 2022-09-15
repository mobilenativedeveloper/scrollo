//
//  AudioMessageView.swift
//  scrollo
//
//  Created by Artem Strelnik on 15.09.2022.
//

import SwiftUI
import DSWaveformImage


import Combine



struct AudioMessageView: View {
    @EnvironmentObject var player: AudioPlayer
    
    @Binding var message: MessageModel
    
    @State var configuration: Waveform.Configuration = Waveform.Configuration(
        style: .striped(.init(color: UIColor(Color(hex: "#5B86E5")), width: 3, spacing: 3)),
        position: .middle
    )
    
    @State var audioURL: URL?
    
    var body: some View {
        HStack(alignment: .top, spacing: 10){
            if message.type == "STARTER" {
                Spacer(minLength: 25)
                // This is my massage
            }
            else {
                Image("testUserPhoto")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 34, height: 34)
                    .cornerRadius(8)
                    .clipped()
                if audioURL == nil {
                    MessageActivityIndicator(color: Color(hex: "#6F83E9"), size: 40)
                }
                else {
                    HStack(spacing: 2.0) {
                        if player.isPlaying {
                            Button(action: {
                                player.stopPlayback()
                            }){
                                Image(systemName: "stop.fill")
                                    .foregroundColor(Color(hex: "#6F83E9"))
                                    .padding(.trailing, 16)
                                    .font(.title)
                            }
                        } else {
                            Button(action: {
                                player.startPlayback(audio: audioURL!)
                            }){
                                Image(systemName: "play.circle")
                                    .foregroundColor(Color(hex: "#6F83E9"))
                                    .padding(.trailing, 16)
                                    .font(.title)
                            }
                        }
                        
                        Spacer()
                        WaveformViewTest(audioURL: $audioURL, configuration: $configuration)
                        Spacer()
                        Text("00:59")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#2E313C"))
                            .padding(.leading, 16)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "F2F2F2"), lineWidth: 1)
                    )
                }
                Spacer(minLength: 25)
            }
        }
        .padding(.vertical)
        .id(message.id)
        .onAppear{
            downloadFile(withUrl: message.audio!) { filePath in
                withAnimation(.easeInOut) {
                    self.audioURL = filePath
                }
            }
        }
    }
    
    func downloadFile(withUrl url: URL, completion: @escaping ((_ filePath: URL)->Void)){
        let filename = UUID().uuidString + ".mp3"
        let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask)[0]
        let audioName = documentDirectory.appendingPathComponent(filename)
        
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                try data.write(to: audioName, options: .atomic)
                print("saved at \(audioName.absoluteString)")
                DispatchQueue.main.async {
                    completion(audioName)
                }
            } catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }
}

struct AudioLoadIndicator: View{
    @State var isAnimating: Bool = false
    let count: Int = 10
    let spacing: CGFloat = 8
    let cornerRadius: CGFloat = 8
    let scaleRange: ClosedRange<Double> = (0.5...1)
    
    var body: some View{
        HStack(spacing: spacing){
            ForEach(0..<Int(count)) { index in
                item(forIndex: index)
            }
        }
        .onAppear{
            isAnimating.toggle()
        }
    }
    
    private var scale: CGFloat { CGFloat(isAnimating ? scaleRange.lowerBound : scaleRange.upperBound) }
    
    private func size(count: Int) -> CGFloat {
        (3/CGFloat(count)) - (spacing-2)
    }
    
    private func item(forIndex index: Int) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.red)
            .frame(width: 3, height: 7)
            .scaleEffect(x: 1, y: scale, anchor: .center)
            .animation(
                Animation
                    .default
                    .repeatCount(isAnimating ? .max : 1, autoreverses: true)
                    .delay(Double(index) / Double(count) / 2)
            )
            .offset(x: CGFloat(index) * (size(count: count) + spacing))
    }
}

struct MessageActivityIndicator: View{
    
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    let timing: Double
        
    let maxCounter = 3
    @State var counter = 0
        
    let frame: CGSize
    let primaryColor: Color

    init(color: Color = .black, size: CGFloat = 50, speed: Double = 0.5) {
        timing = speed / 2
        timer = Timer.publish(every: timing, on: .main, in: .common).autoconnect()
        frame = CGSize(width: size, height: size)
        primaryColor = color
    }

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<maxCounter) { index in
                Circle()
                    .offset(y: counter == index ? -frame.height / 10 : frame.height / 10)
                    .fill(primaryColor)
                }
        }
        .frame(width: frame.width, height: frame.height, alignment: .center)
        .onReceive(timer, perform: { _ in
            withAnimation(.easeInOut(duration: timing * 2)) {
                counter = counter == (maxCounter - 1) ? 0 : counter + 1
            }
        })
    }
}
