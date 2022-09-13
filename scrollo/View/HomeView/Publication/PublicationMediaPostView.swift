//
//  PublicationMediaPostView.swift
//  scrollo
//
//  Created by Artem Strelnik on 09.07.2022.
//

import SwiftUI
import Photos

struct PublicationMediaPostView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var mediaPost: AddMediaPostViewModel = AddMediaPostViewModel()
    @State var present: MediaType = .gallery
    @State private var isPresentCamera: Bool = false
    @State private var isPresentVideoCamera: Bool = false
    
    @State private var isPresentAddMediaPost: Bool = false
    @State var presentationSelectFromAlboum: Bool = false
    
    var body: some View {
        
        VStack {
            
            //MARK: Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("circle_close")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fill)
                }
                Spacer(minLength: 0)
                Button(action: {
                    presentationSelectFromAlboum.toggle()
                }) {
                    HStack {
                        Text("недавние")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .foregroundColor(Color(hex: "#2E313C"))
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                            .font(.title3)
                    }
                }
                Spacer(minLength: 0)
                Button(action: {
                    isPresentAddMediaPost.toggle()
                }) {
                    Image("circle.right.arrow")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fill)
                }
            }
            .padding(.horizontal)
//            .padding(.vertical)
            .background(Color.white)
            .zIndex(1)
            //MARK: List media
            if mediaPost.loadImages {
                if let selection = mediaPost.selection {
                    SelectedPostImageView(multiply: $mediaPost.multiply, pickedPhoto: $mediaPost.pickedPhoto, selection: $mediaPost.selection)
                    ScrollView(showsIndicators: false) {

                        ForEach(0..<mediaPost.allPhotos.count, id: \.self) {index in
                            HStack(spacing: 4) {
                                ForEach(0..<mediaPost.allPhotos[index].count, id: \.self) {key in
                                    Button(action: {
                                        //MARK: If pick multiply photo
                                        if mediaPost.multiply  {


                                            if let index = mediaPost.pickedPhoto.firstIndex(where: {$0.id == mediaPost.allPhotos[index][key].id}) {

                                                if mediaPost.pickedPhoto.count > 1 {

                                                    mediaPost.pickedPhoto.remove(at: index)
                                                    mediaPost.selection! = mediaPost.pickedPhoto[mediaPost.pickedPhoto.count - 1]
                                                }
                                            } else {
                                                mediaPost.selection! = mediaPost.allPhotos[index][key]

                                                if mediaPost.pickedPhoto.count < 5 {

                                                    mediaPost.pickedPhoto.append(mediaPost.allPhotos[index][key])
                                                }
                                            }
                                        } else {
                                            //MARK: If pick one photo
                                            if mediaPost.allPhotos[index][key].id != selection.id {

                                                mediaPost.selection! = mediaPost.allPhotos[index][key]
                                            }
                                            mediaPost.pickedPhoto = [mediaPost.allPhotos[index][key]]
                                        }
                                    }) {
                                        ThumbnailView(pickedPhoto: $mediaPost.pickedPhoto, photo: mediaPost.allPhotos[index][key], multiply: mediaPost.multiply, selection: selection)
                                    }
                                }
                            }
                        }
                        Color.clear.frame(height: 100)
                    }
                }
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
            
        }
        .overlay(
            HStack {
                BottomBarButton(title: "галерея", presentation: MediaType.gallery, action: {})
                BottomBarButton(title: "фото", presentation: MediaType.photo, action: {
                    self.isPresentCamera = true
                })
                BottomBarButton(title: "видео", presentation: MediaType.video, action: {
                    isPresentVideoCamera.toggle()
                })
            }
            .padding(.top ,16)
            .frame(width: UIScreen.main.bounds.width, height: 96,alignment: Alignment(horizontal: .center, vertical: .top))
            .background(Color(hex: "#1F2128"))
            .clipShape(CustomCorner(radius: 18, corners: [.topLeft, .topRight])),
            alignment: Alignment(horizontal: .center, vertical: .bottom)
        )
        .ignoresSafeArea(.all, edges: .bottom)
        //MARK: Add content & published
        .navigationController(isPresent: $isPresentAddMediaPost, content: {
            AddMediaPostView(isPresent: $isPresentAddMediaPost).ignoreDefaultHeaderBar.environmentObject(mediaPost)
        })
        .onAppear(perform: mediaPost.permissions)
        .fullScreenCover(isPresented: self.$presentationSelectFromAlboum, content: {
            ImagePickerView(sourceType: .savedPhotosAlbum) { image in
                mediaPost.pickedPhoto = [Asset(asset: PHAsset(), image: image, withUIImage: true)]
                isPresentAddMediaPost = true
            }
            .edgesIgnoringSafeArea(.all)
            .onDisappear {
                self.present = .gallery
            }
        })
        .fullScreenCover(isPresented: self.$isPresentVideoCamera, content: {
            CameraView(isPresentAddMediaPost: $isPresentAddMediaPost)
                .environmentObject(mediaPost)
        })
        .fullScreenCover(isPresented: self.$isPresentCamera, content: {
            ImagePickerView(sourceType: .camera) { image in

                mediaPost.pickedPhoto = [Asset(asset: PHAsset(), image: image, withUIImage: true)]
                isPresentAddMediaPost = true
            }
            .edgesIgnoringSafeArea(.all)
            .onDisappear {
                self.present = .gallery
            }
        })
    }
    
    @ViewBuilder
    private func BottomBarButton (title: String, presentation: MediaType, action: @escaping () -> Void) -> some View {
        
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.system(size: 18))
                .fontWeight(self.present == presentation ? .bold : .none)
                .textCase(.uppercase)
                .foregroundColor(self.present == presentation ? Color(hex: "#5B86E5") : Color(hex: "#828796"))
        }
        .frame(width: (UIScreen.main.bounds.width / 3) - 23)
    }
}

struct PublicationMediaPostView_Previews: PreviewProvider {
    static var previews: some View {
        PublicationMediaPostView()
    }
}

enum MediaType {
    case gallery, photo, video
}

private struct ThumbnailView: View {
    @Binding var pickedPhoto: [Asset]
    var photo: Asset
    let multiply: Bool
    let selection: Asset
    let size = (UIScreen.main.bounds.width / 3) - 8
    
    var body: some View{
        
        ZStack(alignment: .bottomTrailing) {
            
            ZStack(alignment: .topTrailing) {
                
                Image(uiImage: photo.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .cornerRadius(10)
                    .overlay(
                        Color.white.opacity(selection.id == photo.id ? 0.4 : 0)
                    )
                if multiply {
                    
                    ZStack {
                        
                        let number = self.getNumber()
                        
                        Circle()
                            .strokeBorder(Color.white,lineWidth: 1)
                            .background(Circle().foregroundColor(self.checkSelect() ? Color(hex: "#66b0ff") : Color.white.opacity(0.3)))
                            .frame(width: 20, height: 20)
                        
                        if number != -1 {
                            
                            Text("\(number)")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 20, height: 20)
                    .offset(x: -8, y: 8)
                }
            }
            if photo.asset.mediaType == .video {
                
                Image(systemName: "video.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(8)
            }
        }
    }
    
    func getNumber () -> Int {
        
        if let index = pickedPhoto.firstIndex(where: { $0.id == photo.id}) {
            
            return index + 1
        } else {
            
            return -1
        }
    }
    func checkSelect () -> Bool {
        
        if let _ = pickedPhoto.firstIndex(where: { $0.id == photo.id}) {
            
            return true
        } else {
            
            return false
        }
    }
}

private struct SelectedPostImageView: View {
    @Binding var multiply: Bool
    @Binding var pickedPhoto: [Asset]
    @Binding var selection: Asset?
    @State var help: Bool? = nil
    
    var body : some View{
        
        ZStack(alignment: .bottomTrailing) {
            
            Image(uiImage: selection?.image ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: 300)
                .clipped()
            
            Button(action: {
                
                if multiply {
                    
                    if let last = pickedPhoto.last {
                        
                        selection = last
                        pickedPhoto = [last]
                    }
                    
                    multiply = false
                } else {
                    
                    multiply = true
                }
            }) {
                
                HStack {
                    
                    Image("group")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .aspectRatio(contentMode: .fit)
                    Text("выбрать несколько")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            .background(multiply ? Color(hex: "#66b0ff").opacity(0.7) : Color(hex: "#1F2128").opacity(0.7))
            .cornerRadius(16)
            .offset(x: -18, y: -21)
            .overlay(
                VStack(spacing: 0) {
                    Text("Вы можете разместить до 5 фото и видео в одной публикации.")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .padding(10)
                }
                .background(Color(hex: "#282828"))
                .cornerRadius(7)
                    .frame(width: 280, height: 70)
                .overlay(
                    Triangle()
                        .fill(Color(hex: "#282828"))
                        .frame(width: 15, height: 8, alignment: .center)
                        .rotationEffect(.init(degrees: 180))
                        .offset(x: -20, y: -5),
                    alignment: Alignment(horizontal: .trailing, vertical: .bottom)
                ).offset(x: -5, y: -65).opacity(self.help == true ? 1 : 0),
                alignment: .trailing
            )
        }
        .frame(height: 300)
        .onAppear {
            
            if self.help == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.default) {
                        self.help = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.default) {
                            self.help = false
                        }
                    }
                }
            }
        }
    }
}

struct AddMediaPostView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var mediaPost: AddMediaPostViewModel
    @Binding var isPresent: Bool
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                Button(action: {
                    if !mediaPost.isPublished {
                        isPresent.toggle()
                        mediaPost.pickedPhoto = [mediaPost.allPhotos[0][0]]
                        mediaPost.selection = mediaPost.allPhotos[0][0]
                        mediaPost.content = ""
                    }
                }) {
                    Image("circle_close")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fill)
                }
                Spacer(minLength: 0)
                Text("Публикация")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(Color(hex: "#2E313C"))
                Spacer(minLength: 0)
                Button(action: {
                    mediaPost.publish { post in
//                        guard let post = post else {return}
                        
                        isPresent.toggle()
                        mediaPost.pickedPhoto = [mediaPost.allPhotos[0][0]]
                        mediaPost.selection = mediaPost.allPhotos[0][0]
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    if mediaPost.isPublished {
                        ProgressView()
                    } else {
                        Image("circle.right.arrow")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .aspectRatio(contentMode: .fill)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 14)
            
            
            VStack(spacing: 0) {
                
                TabView {
                    ForEach(0..<mediaPost.pickedPhoto.count, id: \.self) {index in
                        Image(uiImage: mediaPost.pickedPhoto[index].image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                            .background(Color.black)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("отметить людей")
                        .foregroundColor(Color(hex: "#828796"))
                    Spacer(minLength: 0)
                    Text(">")
                        .foregroundColor(Color(hex: "#828796"))
                }
                .padding(.horizontal, 26)
                .padding(.vertical, 20)
                HStack(spacing: 0) {
                    Text("добавить место")
                        .foregroundColor(Color(hex: "#828796"))
                    Spacer(minLength: 0)
                    Text(">")
                        .foregroundColor(Color(hex: "#828796"))
                }
                .padding(.horizontal, 26)
                .padding(.vertical, 20)
            }
            .background(Color(hex: "#1F2128"))
            
            TextEditor(text: $mediaPost.content)
                .padding()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .onTapGesture(perform: {
            UIApplication.shared.endEditing()
        })
    }
}
