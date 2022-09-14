//
//  VoiceRecordView.swift
//  scrollo
//
//  Created by Artem Strelnik on 14.09.2022.
//

import SwiftUI

import Foundation
import AVFoundation

import DSWaveformImage


struct VoiceRecordView: View {
    @Binding var isVoiceRecord: Bool
    @StateObject private var audioRecorder: AudioRecorder = AudioRecorder()
    
    @State var liveConfiguration: Waveform.Configuration = Waveform.Configuration(
        style: .striped(.init(color: .white, width: 3, spacing: 3)),
        position: .middle
    )
    
    static let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View{
        if isVoiceRecord{
            HStack{
                Button(action: {
                    withAnimation(.easeInOut){
                        audioRecorder.isRecording.toggle()
                        isVoiceRecord.toggle()
                    }
                }) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                }
                .padding(.leading)
                Spacer()
                
                WaveformLiveCanvas(
                    samples: $audioRecorder.samples,
                    configuration: $liveConfiguration,
                    shouldDrawSilencePadding: .constant(true)
                )
                Spacer()
                Text("\(Self.timeFormatter.string(from: audioRecorder.recordingTime) ?? "00:00")")
                    .foregroundColor(.white)
                Button(action: {
                    
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                }
                .padding(.trailing)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    Color(hex: "#36DCD8"),
                    Color(hex: "#5B86E5")
                ]), startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .clipped()
            .onAppear{
                audioRecorder.isRecording.toggle()
            }
        }
    }
}

private class AudioRecorder: NSObject, ObservableObject, RecordingDelegate {
    @Published var samples: [Float] = []
    @Published var recordingTime: TimeInterval = 0
    @Published var isRecording: Bool = false {
        didSet {
            guard oldValue != isRecording else { return }
            isRecording ? startRecording() : stopRecording()
        }
    }

    private let audioManager: SCAudioManager

    override init() {
        audioManager = SCAudioManager()

        super.init()

        audioManager.prepareAudioRecording()
        audioManager.recordingDelegate = self
    }

    func startRecording() {
        samples = []
        audioManager.startRecording()
        isRecording = true
    }

    func stopRecording() {
        audioManager.stopRecording()
        isRecording = false
    }

    // MARK: - RecordingDelegate
    func audioManager(_ manager: SCAudioManager!, didAllowRecording flag: Bool) {}

    func audioManager(_ manager: SCAudioManager!, didFinishRecordingSuccessfully flag: Bool) {}

    func audioManager(_ manager: SCAudioManager!, didUpdateRecordProgress progress: CGFloat) {
        let linear = 1 - pow(10, manager.lastAveragePower() / 20)

        // Here we add the same sample 3 times to speed up the animation.
        // Usually you'd just add the sample once.
        recordingTime = audioManager.currentRecordingTime
        samples += [linear, linear, linear]
    }
}
