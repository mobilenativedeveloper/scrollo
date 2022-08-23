//
//  ImageCropperViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.08.2022.
//

import SwiftUI

class SimpleImageCropperViewModel: ObservableObject {

    @Published var image: UIImage?
    @Published var maximumScale: CGFloat = 2.0
    @Published var clipRadius: CGFloat = 150.0
    @Published var clipRatio: CGFloat = 1.0
    @Published var handleSize: CGFloat = 10.0
    @Published var areaRadius: CGFloat = 0.0
    @Published var _scale: CGFloat = 1.0
    @Published var _ratio: CGFloat = 1.0
    @Published var _view: CGRect = CGRect.zero
    @Published var _area: CGRect = CGRect.zero
    @Published var _lastFocalPoint: CGPoint = CGPoint.zero
    @Published var startScale: CGFloat?
    @Published var startView: CGRect?
    
    func scale() -> CGFloat {
        return min(abs(_area.width), abs(_area.height)) / _scale
    }
    
    func area () -> CGRect? {
        return _view.isEmpty ? nil : CGRect(
            x: _area.minX * _view.width / _scale - _view.minX,
            y: _area.minY * _view.height / _scale - _view.minY,
            width: _area.width * _view.width / _scale,
            height: _area.height * _view.height / _scale
        )
    }
    
    func _isEnabled () -> Bool {
        return !_view.isEmpty && image != nil
    }

    func _boundaries () -> CGSize {
        let w = UIScreen.main.bounds.size.width - handleSize
        let h = UIScreen.main.bounds.size.height - handleSize
        return CGSize(width: w, height: h)
    }


    func _calculateDefaultArea (
        imageWidth: CGFloat,
        imageHeight: CGFloat,
        viewWidth: CGFloat,
        viewHeight: CGFloat
    ) -> CGRect {

        let deviceWidth = UIScreen.main.bounds.width - (2 * handleSize)
        let areaOffset = (deviceWidth - (clipRatio * 2))
        let areaOffsetRadio = areaOffset / deviceWidth
        let width = 1.0 - areaOffsetRadio
        let height = (imageWidth * viewWidth * width) / (imageHeight * viewHeight * 1.0)

        return CGRect(x: (1.0 - width) / 2, y: (1.0 - height) / 2, width: width, height: height)
    }
    
    func _updateImage () {
        _ratio = max(_boundaries().width / image!.size.width, _boundaries().height / image!.size.height)
        let viewWidth = _boundaries().width / (image!.size.width * _scale * _ratio)
        let viewHeight = _boundaries().height / (image!.size.height * _scale * _ratio)
        _area = _calculateDefaultArea(imageWidth: image!.size.width, imageHeight: image!.size.height, viewWidth: viewWidth, viewHeight: viewHeight)
        _view = CGRect(x: (viewWidth - 1.0) / 2, y: (viewHeight - 1.0) / 2, width: viewWidth, height: viewHeight)
    }
    
}


class ImageCropperViewModel: ObservableObject {

    @Published var image: UIImage?

    @Published var cropperFrameRect: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)

    @Published var imageCoordinate: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    @Published var cropFrameCoordinate: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)

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
                print("current position: \(self.currentPosition.width / self.scale)")
            }
            .onEnded { value in
                
                

                self.newPosition = self.currentPosition
        }
    }

    func pinchController () -> some Gesture {
        return MagnificationGesture(minimumScaleDelta: 0.1)
            .onChanged { value in
                let resolvedDelta = value / self.lastValue
                self.lastValue = value
                let newScale = self.scale * resolvedDelta
                self.scale = min(self.maxScale, max(self.minScale, newScale))
            }.onEnded { value in
                self.lastValue = 1.0
            }
    }
}
