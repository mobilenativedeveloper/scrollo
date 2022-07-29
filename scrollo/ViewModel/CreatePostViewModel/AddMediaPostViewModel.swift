//
//  AddMediaPostViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 09.07.2022.
//

import SwiftUI
import Photos
import AVKit

enum LibraryStatus {
    case denied
    case approved
    case limited
}

class AddMediaPostViewModel: ObservableObject {
    @Published var library_status: LibraryStatus = LibraryStatus.denied
    @Published var loadImages: Bool = false
    
    @Published var allPhotos: [[Asset]] = []
    
    @Published var multiply: Bool = false
    
    @Published var pickedPhoto: [Asset] = []
    @Published var selection: Asset? = nil
    
    @Published var content: String = ""
    
    @Published var alert: AlertModel = AlertModel(title: "", message: "", show: false)
    
    @Published var isPublished: Bool = false
    
    private var uploadFiles: [MultipartMedia] = []
    
    func permissions () -> Void {
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [self](status) in
            
            DispatchQueue.main.async {
                switch status {
                    case .denied: self.library_status = .denied
                    case .authorized:
                        self.library_status = .approved
                        if self.allPhotos.isEmpty {
                            self.getPhotoLibrary()
                        }
                    case .limited:
                        self.library_status = .limited
                        if self.allPhotos.isEmpty {
                            self.getPhotoLibrary()
                        }
                    default: self.library_status = .denied
                }
            }
        }
    }
    
    func getPhotoLibrary () -> Void {
        
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        options.includeHiddenAssets = false
        
        let library = PHAsset.fetchAssets(with: options)
        var imageStack: [Asset] = []
        
        library.enumerateObjects {[self] (asset, index, _) in
            getImageFromAsset(asset: asset) { (image) in
                imageStack.append(Asset(asset: asset, image: image))
                
                if imageStack.count == 3 {
                    self.allPhotos.append(imageStack)
                    imageStack.removeAll()
                }
                
                if index == library.count - 1 {
                    DispatchQueue.main.async {
                        self.pickedPhoto.append(self.allPhotos[0][0])
                        self.selection = self.allPhotos[0][0]
                        self.loadImages = true
                    }
                }
            }
        }
         
    }
    
    
    func getImageFromAsset (asset: PHAsset, completion: @escaping(UIImage) -> ()) -> Void {
        
        let imageManager = PHCachingImageManager()
        imageManager.allowsCachingHighQualityImages = true
        
        let imageOptions = PHImageRequestOptions()
        imageOptions.deliveryMode = .highQualityFormat
        imageOptions.isSynchronous = false
        
        let size = CGSize(width: 600, height: 600)
        
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: imageOptions) { image, _ in
            
            guard let resizedImage = image else {return}
            completion(resizedImage)
        }
    }
    
    func requestAVAsset(asset: PHAsset)-> AVAsset? {
            guard asset.mediaType == .video else { return nil }
            let phVideoOptions = PHVideoRequestOptions()
            phVideoOptions.version = .original
            let group = DispatchGroup()
            let imageManager = PHImageManager.default()
            var avAsset: AVAsset?
            group.enter()
            imageManager.requestAVAsset(forVideo: asset, options: phVideoOptions) { (asset, _, _) in
                avAsset = asset
                group.leave()
                
            }
            group.wait()
            
            return avAsset
        }

    
    func publish (completion: @escaping (PostModel?) -> Void) -> Void {
        self.isPublished = true
        
        guard let url = URL(string: "\(API_URL)\(API_ADD_POST)") else {return}
        guard let token = UserDefaults.standard.string(forKey: "token") else {return}
        
        let boundary = generateBoundary()
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var files: [MultipartMedia] = []
        
        for photo in self.pickedPhoto {
            if photo.withUIImage {
                guard let image = photo.image.jpegData(compressionQuality: 0.7) else {return}
                let media = MultipartMedia(key: "files", filename: "image.jpg", data: image, mimeType: "image/jpeg")

                files.append(media)
            } else {
                if let url = photo.withAVCamera {
                    if let data = NSData(contentsOf: url) {
                        let video: Data = Data(data)
                        files.append(MultipartMedia(key: "files", filename: "video.mp4", data: video, mimeType: "video/mp4"))
                    }
                } else {
                    if photo.asset.mediaType == .video {
                        let asset = self.requestAVAsset(asset: photo.asset)
                        if let asset = asset as? AVURLAsset, let data = NSData(contentsOf: asset.url) {
                            let video: Data = Data(data)
                            files.append(MultipartMedia(key: "files", filename: "video.mp4", data: video, mimeType: "video/mp4"))
                        }
                    }
                    
                    if photo.asset.mediaType == .image {
                        guard let image = photo.image.jpegData(compressionQuality: 0.7) else {return}
                        let media = MultipartMedia(key: "files", filename: "image.jpg", data: image, mimeType: "image/jpeg")

                        files.append(media)
                    }
                }
            }
        }
       
        request.httpBody = createDataBody(withParameters: ["content": self.content, "type": "STANDART"], media: files, boundary: boundary)

        URLSession.shared.dataTask(with: request) { data, response, _ in

            guard let response = response as? HTTPURLResponse else {return}
            guard let data = data else {return}
            
            if response.statusCode == 201 {

                guard let post = try? JSONDecoder().decode(PostModel.self, from: data) else {return}

                DispatchQueue.main.async {
                    self.isPublished = false
                    completion(post)
                }
            } else {
                DispatchQueue.main.async {
                    self.isPublished = false
                    self.alert = AlertModel(title: "Ошибка", message: "Не удалось опубликовать пост, попробуйте еще раз.", show: true)
                }
            }
        }.resume()
    }
}

extension PHAsset {
    func getImage() -> UIImage? {
        let manager = PHCachingImageManager.default
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        var img: UIImage? = nil
        manager().requestImage(for: self, targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight), contentMode: .aspectFit, options: nil, resultHandler: {(result, info) -> Void in
            img = result!
        })
        return img
    }

    func getVideo() -> NSData? {
        let manager = PHCachingImageManager.default
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        var resultData: NSData? = nil
    
        manager().requestAVAsset(forVideo: self, options: nil) { (asset, audioMix, info) in
            if let asset = asset as? AVURLAsset, let data = NSData(contentsOf: asset.url) {
                resultData = data
            }
        }
        return resultData
    }
}
