//
//  AlbumViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 28.07.2022.
//

import SwiftUI


class AddAlbumViewModel: ObservableObject {
    @Published var isAddAlbum: Bool = false
    @Published var name: String = String()
    @Published var alert: AlertModel = AlertModel(title: "", message: "", show: false)
    
    @Published var status: AlbumStatus = AlbumStatus.initial
    
    func createAlboum () {
        if self.name.isEmpty {
            self.alert = AlertModel(title: "Ошибка", message: "Введите название альбома.", show: true)
            return
        }
        
        self.status = AlbumStatus.load
        
        guard let url = URL(string: "\(API_URL)\(API_SAVED_ALBUM)") else { return }
        guard let request = Request(url: url, httpMethod: "POST", body: ["name": self.name]) else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else { return }
            guard let data = data else {return}
            
            if response.statusCode == 201 {
                guard let responseJson = try? JSONDecoder().decode(AlbumModel.self, from: data) else {return}
                
                DispatchQueue.main.async {
                    self.status = AlbumStatus.success
                    self.alert = AlertModel(title: "Успех", message: "Альбом успешно создан.", show: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.status = AlbumStatus.error
                    self.alert = AlertModel(title: "Ошибка", message: "Произошла ошибка, попробуйе еще раз.", show: true)
                }
            }
        }.resume()
                
        
    }
}
