//
//  ImageCropperViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.08.2022.
//

import SwiftUI

class ImageCropperViewModel: ObservableObject {
    
    @Published var image: UIImage?
    
    @Published var cropperFrameRect: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
    
    @Published var imageCoordinate: CGPoint = CGPoint(x: 0, y: 0)
    @Published var cropFrameCoordinate: CGPoint = CGPoint(x: 0, y: 0)
    
    @Published var currentPosition: CGSize = .zero
    @Published var newPosition: CGSize = .zero
    
    @Published var scale: CGFloat = 1.0
    @Published var lastValue: CGFloat = 1.0
    let maxScale: CGFloat = 3.0
    let minScale: CGFloat = 1.0
    
    func dragController () -> some Gesture {
        return DragGesture()
            .onChanged { (value) in
                self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
            }
            .onEnded { value in
                //MARK: Limit top leading angle
                if self.imageCoordinate.x > self.cropFrameCoordinate.x && self.imageCoordinate.y > self.cropFrameCoordinate.y {
                    withAnimation(.default) {
                        print("Limit top leading angle")
                        self.currentPosition.width = self.cropFrameCoordinate.x
                        self.currentPosition.height = self.currentPosition.height - (self.imageCoordinate.y - self.cropFrameCoordinate.y)
                    }
                    self.newPosition = self.currentPosition
                    return
                }
                //MARK: Limit top trailing angle
                if self.imageCoordinate.x < (-self.cropFrameCoordinate.x) && self.imageCoordinate.y > self.cropFrameCoordinate.y {
                    withAnimation(.default) {
                        print("Limit top trailing angle")
                        self.currentPosition.width = -self.cropFrameCoordinate.x
                        self.currentPosition.height = self.currentPosition.height - (self.imageCoordinate.y - self.cropFrameCoordinate.y)
                    }
                    self.newPosition = self.currentPosition
                    return
                }
                //MARK: Limit bottom trailing angle
                if self.imageCoordinate.x < (-self.cropFrameCoordinate.x) && self.imageCoordinate.y > (-self.cropFrameCoordinate.y) {
                    withAnimation(.default) {
                        print("Limit bottom trailing angle")
                        self.currentPosition.width = -self.cropFrameCoordinate.x
                        self.currentPosition.height = -(self.currentPosition.height - (self.imageCoordinate.y - self.cropFrameCoordinate.y))
                    }
                    self.newPosition = self.currentPosition
                    return
                }
                //MARK: Limit bottom leading angle
                if self.imageCoordinate.x > self.cropFrameCoordinate.x && self.imageCoordinate.y > (-self.cropFrameCoordinate.y) {
                    withAnimation(.default) {
                        print("Limit bottom leading angle")
                        self.currentPosition.width = self.cropFrameCoordinate.x
                        self.currentPosition.height = -(self.currentPosition.height - (self.imageCoordinate.y - self.cropFrameCoordinate.y))
                    }
                    self.newPosition = self.currentPosition
                    return
                }
                //MARK: Limit left edge
                if self.imageCoordinate.x > self.cropFrameCoordinate.x {
                    print("Limit left edge")
                    withAnimation(.default) {
                        self.currentPosition.width = self.cropFrameCoordinate.x
                    }
                    self.newPosition = self.currentPosition
                    return
                }
                //MARK: Limit right edge
                if self.imageCoordinate.x < (-self.cropFrameCoordinate.x) {
                    print("Limit right edge")
                    withAnimation(.default) {
                        self.currentPosition.width = -self.cropFrameCoordinate.x
                    }
                    self.newPosition = self.currentPosition
                    return
                }
                //MARK: Limit top edge
                if self.imageCoordinate.y > self.cropFrameCoordinate.y {
                    print("Limit top edge")
                    withAnimation(.default) {
                        self.currentPosition.height = self.currentPosition.height - (self.imageCoordinate.y - self.cropFrameCoordinate.y)
                    }
                    self.newPosition = self.currentPosition
                    return
                }
                //MARK: Limit bottom edge
                if self.imageCoordinate.y > (-self.cropFrameCoordinate.y) {
                    print("Limit bottom edge")
                    withAnimation(.default) {
                        self.currentPosition.height = -(self.currentPosition.height - (self.imageCoordinate.y - self.cropFrameCoordinate.y))
                    }
                    self.newPosition = self.currentPosition
                    return
                }
        }
    }
//
//    func pinchController () -> MagnificationGesture {
//        return MagnificationGesture(minimumScaleDelta: 0.1)
//            .onChanged { value in
//                let resolvedDelta = value / self.lastValue
//                self.lastValue = value
//                let newScale = self.scale * resolvedDelta
//                self.scale = min(self.maxScale, max(self.minScale, newScale))
//            }.onEnded { value in
//                self.lastValue = 1.0
//            }
//    }
}
