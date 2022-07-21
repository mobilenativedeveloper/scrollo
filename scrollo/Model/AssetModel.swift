//
//  AssetModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 10.07.2022.
//

import SwiftUI
import Photos

struct Asset: Identifiable {
    var id = UUID().uuidString
    var asset: PHAsset
    var image: UIImage
    var withUIImage: Bool = false
    var withAVCamera: URL? = nil
}

