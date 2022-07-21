//
//  EditUserProfile.swift
//  scrollo
//
//  Created by Artem Strelnik on 07.07.2022.
//

import SwiftUI
import UIKit
import  SDWebImageSwiftUI

struct EditUserProfile: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var profile: ProfileViewModel
    @StateObject var edit: EditProfileViewModel = EditProfileViewModel.init()
    
    @State var selectedBackground: UIImage = UIImage()
    @State var selectedAvatar: UIImage = UIImage()
    @State var isGalleryPickerBackground: Bool = false
    @State var isGalleryPickerAvatar: Bool = false
    @State private var sourceTypeBackground: UIImagePickerController.SourceType = .photoLibrary
    @State private var sourceTypeAvatar: UIImagePickerController.SourceType = .photoLibrary
    @State var showingOptions: Bool = false
    @State var optionsMenu: EditUserTumbs = .avatar
    
    private let genders = ["Мужской", "Женский"]
    private let widthPhotoEdit: CGFloat = UIScreen.main.bounds.width - 44
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                HStack {
                    Button(action: {
                        if !edit.loadEdit {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image("circle_close")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .aspectRatio(contentMode: .fill)
                    }
                    Spacer(minLength: 0)
                    VStack(spacing: 4) {
                        Text(edit.login)
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#828796"))
                        Text("Ваш профиль")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .foregroundColor(Color(hex: "#2E313C"))
                    }
                    Spacer(minLength: 0)
                    Button(action: {
                        if !edit.loadEdit {
                            edit.editProfile(onSuccess: {
                                profile.getProfile(userId: UserDefaults.standard.string(forKey: "userId")!)
                                edit.alertTitle = "Успех"
                                edit.alertMessage = "Профиль успешно изменен"
                                edit.alert.toggle()
                                presentationMode.wrappedValue.dismiss()
                            })
                        }
                    }) {
                            if edit.loadEdit {
                                ProgressView()
                            } else {
                                Image("circle_blue_checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                    }
                .padding(.horizontal)
                Rectangle()
                    .fill(Color(hex: "#F2F2F2"))
                    .frame(height: 1)
                    .padding(.horizontal, 27)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                 
                    HStack(spacing: 0) {
                        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                            if let avatar = edit.avatar {
                                WebImage(url: URL(string: "\(API_URL)/uploads/\(avatar)")!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 87, height: 87)
                                    .clipped()
                                    .background(Color(hex: "#f7f7f7"))
                                    .cornerRadius(22)
                            } else {
                                UIDefaultAvatar(width: 87, height: 87, cornerRadius: 22)
                                    .clipped()
                            }
                            Image("edit_user_photo")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .offset(x: 7, y: 5)
                        }
                        .frame(width: self.widthPhotoEdit / 3, height: 100, alignment: Alignment(horizontal: .leading, vertical: .center))
                        .shadow(color: Color(hex: "#909eab").opacity(0.1), radius: 7, y: 10)
                        .padding(.trailing, 23)
                        .onTapGesture {
                            self.optionsMenu = .avatar
                            self.showingOptions.toggle()
                        }
                        Button(action: {
                            self.optionsMenu = .background
                            self.showingOptions.toggle()
                        }) {
                            ZStack {
                                VStack {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 16, height: 17)
                                        .clipped()
                                        .foregroundColor(Color(hex: textBgColor()))
                                    Text("выберите обложку вашего аккаунта")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color(hex: textBgColor()))
                                        .frame(width: 110)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    .fill(Color(hex: "#828796"))
                                    .frame(width: widthPhotoEdit / 2, height: 70)
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(style: StrokeStyle(lineWidth: 1))
                                    .fill(Color(hex: "#828796"))
                                    .frame(width: widthPhotoEdit / 1.8, height: 87)
                            )
                            .background(UserBackgroundView())
                        }
                        .frame(width: widthPhotoEdit / 1.8, height: 87)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 27)
                    EdtiProfileTextField(text: $edit.name, label: "Имя", isLarge: false)
                    EdtiProfileTextField(text: $edit.login, label: "Аккаунт", isLarge: false)
                    EdtiProfileTextField(text: $edit.career, label: "Карьера", isLarge: false)
                    EdtiProfileTextField(text: $edit.website, label: "Сайт", isLarge: false)
                    EdtiProfileTextField(text: $edit.bio, label: "О себе", isLarge: true)
                    Text("Персональные данные")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2E313C"))
                        .padding(.top, 9)
                        .padding(.bottom, 6)
                        .padding(.horizontal, 27)
                    EdtiProfileTextField(text: $edit.email, label: "Email", isLarge: false)
                    EdtiProfilePhoneTextField(text: $edit.phone, label: "Телефон")
                    HStack {
                        Text("Пол")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#828796"))
                            .padding(.vertical, 15)
                            .padding(.trailing, 24)
                            .frame(width: (UIScreen.main.bounds.width - 54) / 3.5, alignment: Alignment(horizontal: .leading, vertical: .center))
                        VStack(alignment: .leading, spacing: 0) {
                            Picker("Выберите пол", selection: $edit.genderSelection) {
                                ForEach(genders, id: \.self) {
                                    Text($0)
                                        .font(Font.headline.weight(.semibold))
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "#000000"))
                                        .padding(.vertical, 15)
                                }
                            }
                            Rectangle()
                                .fill(Color(hex: "#F2F2F2"))
                                .frame(height: 1)
                        }
                    }
                    .padding(.horizontal, 27)
                }
            }
        }
        .fullScreenCover(isPresented: self.$isGalleryPickerBackground, content: {
            ImagePickerCameraView(selectedImage: self.$selectedBackground, sourceType: self.sourceTypeBackground) {
                if self.selectedBackground != UIImage() {
                    edit.updateUserBackground(background: self.selectedBackground) {
                        edit.getProfile(userId: UserDefaults.standard.string(forKey: "userId")!)
                        self.edit.alertTitle = "Успех"
                        self.edit.alertMessage = "Фон успешно изменен"
                        self.edit.alert.toggle()
                    }
                }
            }.edgesIgnoringSafeArea(.all)
        })
        .fullScreenCover(isPresented: self.$isGalleryPickerAvatar, content: {
            ImagePickerCameraView(selectedImage: self.$selectedAvatar, sourceType: self.sourceTypeAvatar) {
                if self.selectedAvatar != UIImage() {
                    edit.updateUserAvatar(avatar: self.selectedAvatar) {
                        edit.getProfile(userId: UserDefaults.standard.string(forKey: "userId")!)
                        self.edit.alertTitle = "Успех"
                        self.edit.alertMessage = "Фото успешно изменено"
                        self.edit.alert.toggle()
                    }
                }
            }.edgesIgnoringSafeArea(.all)
        })
        .alert(isPresented: $edit.alert) {
            Alert(title: Text(edit.alertTitle), message: Text(edit.alertMessage), dismissButton: .default(Text("Продолжить")))
        }
        .actionSheet(isPresented: $showingOptions) {
            if optionsMenu == .background {
                return ActionSheet(title: Text("Добавить Фон профиля"), buttons: [
                    .default(Text("Сделать фото")) {
                        self.sourceTypeBackground = .camera
                        self.isGalleryPickerBackground.toggle()
                    },
                    .default(Text("Выбрать из галереи")) {
                        self.sourceTypeBackground = .photoLibrary
                        self.isGalleryPickerBackground.toggle()
                    },
                    .cancel(Text("Отмена"))
                ])
            } else {
                return ActionSheet(title: Text("Добавить фото профиля"), buttons: [
                    .default(Text("Сделать фото")) {
                        self.sourceTypeAvatar = .camera
                        self.isGalleryPickerAvatar.toggle()
                    },
                    .default(Text("Выбрать из галереи")) {
                        self.sourceTypeAvatar = .photoLibrary
                        self.isGalleryPickerAvatar.toggle()
                    },
                    .cancel(Text("Отмена"))
                ])
            }
        }
    }
    
    @ViewBuilder
    func UserBackgroundView () -> some View {
        if let background = edit.background {
            WebImage(url: URL(string: "\(API_URL)/uploads/\(background)")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: widthPhotoEdit / 1.8, height: 87)
                .cornerRadius(15)
        } else {
            Color.clear
        }
    }
    
    func textBgColor () -> String {
        if let background = profile.user!.background {
            if !background.isEmpty && selectedBackground == nil {
                return "#ffffff"
            }
        } else if selectedBackground != UIImage() {
            return "#ffffff"
        } else {
            return "#828796"
        }
        return "#828796"
    }
}

struct EditUserProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditUserProfile()
    }
}

private struct EdtiProfileTextField : View {
    @Binding var text: String
    var label: String
    
    var isLarge: Bool
    let width: CGFloat = UIScreen.main.bounds.width - 54
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#828796"))
                .padding(.vertical, 15)
                .padding(.trailing, 24)
                .frame(width: width / 3.5, alignment: Alignment(horizontal: .leading, vertical: .center))
            VStack(spacing: 0) {
                if !isLarge {
                    TextField("", text: $text)
                        .font(Font.headline.weight(.semibold))
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#000000"))
                        .padding(.vertical, 15)
                } else {
                    ZStack(alignment: .leading) {
                        TextEditor(text: $text)
                            .font(Font.headline.weight(.semibold))
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#000000"))
                            .frame(minHeight: 50, maxHeight: 50, alignment: .topLeading)
                            .padding(.vertical, 15)
                    }
                }
                Rectangle()
                    .fill(Color(hex: "#F2F2F2"))
                    .frame(height: 1)
            }
        }
        .frame(width: width)
        .padding(.horizontal, 27)
    }
}

private struct EdtiProfilePhoneTextField : View {
    @Binding var text: String
    var label: String
    
    let width: CGFloat = UIScreen.main.bounds.width - 54
    let phoneMask: String = "+X XXX XXX XX XX"
    
    var body: some View {
        
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#828796"))
                .padding(.vertical, 15)
                .padding(.trailing, 24)
                .frame(width: width / 3.5, alignment: Alignment(horizontal: .leading, vertical: .center))
            VStack(spacing: 0) {
                TextField("+0 000 000 00 00", text: $text)
                    .keyboardType(.numberPad)
                    .onChange(of: text, perform: { value in
                        if value.count > 16 {
                            text = String(value.prefix(16))
                        } else {
                            text = format(with: phoneMask, phone: value)
                        }
                      })
                    .font(Font.headline.weight(.semibold))
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#000000"))
                    .padding(.vertical, 15)
                Rectangle()
                    .fill(Color(hex: "#F2F2F2"))
                    .frame(height: 1)
            }
        }
        .frame(width: width)
        .padding(.horizontal, 27)
    }
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

enum EditUserTumbs {
    case avatar
    case background
}

class CoordinatorImagePickerCameraView: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerCameraView
    var complited: () -> Void
    
    init(picker: ImagePickerCameraView, complited: @escaping () -> Void) {
        self.picker = picker
        self.complited = complited
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
        self.complited()
    }
    
}


struct ImagePickerCameraView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
    var complited: () -> Void
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> CoordinatorImagePickerCameraView {
        return CoordinatorImagePickerCameraView(picker: self, complited: self.complited)
    }
}


