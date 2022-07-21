//
//  CreateThumbnailFromVideo.swift
//  scrollo
//
//  Created by Artem Strelnik on 12.07.2022.
//

import AVFoundation
import SwiftUI

func createThumbnailFromVideo(path: String) -> UIImage? {
    let video = AVURLAsset(url: URL(fileURLWithPath: path))
    let thumbnailGenerator = AVAssetImageGenerator(asset: video)
    do {
        let cgImage = try thumbnailGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let UiImage = UIImage(cgImage: cgImage)
        return UiImage
    } catch {
        print("*** Error generating thumbnail: ", error)
        return nil
    }
}
