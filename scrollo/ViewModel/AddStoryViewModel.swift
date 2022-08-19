//
//  AddStoryViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 19.08.2022.
//

import SwiftUI
import Photos
import PhotosUI

class AddStoryViewModel : ObservableObject {
    @Published var loadAlbums: Bool = false
    @Published var loadAssets: Bool = false
    @Published var albums: [PHAssetCollection] = []
    @Published var selectedAlbum: Int = 0
    @Published var assets: [UIImage] = []
    
    
    init () {
        getAlbums()
    }
    
    func getAlbums () -> Void {
        print("fetch albums")
        let fetchOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        smartAlbums.enumerateObjects { (assetCollection, index, stop) in
            if assetCollection.localizedTitle == "Recents" {
                self.albums.append(assetCollection)
            }
        }
        
        userAlbums.enumerateObjects { [self](assetCollection, index, stop) in
            self.albums.append(assetCollection)
        }
        
        
        self.loadAlbums.toggle()
        self.getThumbnailAssetsFromAlbum()
    }
    
    
    func getThumbnailAssetsFromAlbum () {
        self.loadAssets = false
        self.assets = []
        let fetchOptions = PHFetchOptions()
        
        let assetsAlbum = PHAsset.fetchAssets(in: self.albums[self.selectedAlbum], options: fetchOptions)

        assetsAlbum.enumerateObjects { asset, index, _ in
            let imageManager = PHCachingImageManager()
            let imageOptions = PHImageRequestOptions()
            
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 700, height: 700), contentMode: .default, options: imageOptions, resultHandler: { img, _ in
                if let img = img {
                    DispatchQueue.main.async {
                        self.assets.append(img)
                    }
                }
            })
            
            DispatchQueue.main.async {
                if index == assetsAlbum.count - 1 {
                    self.loadAssets = true
                }
            }
        }
        
    }
}
