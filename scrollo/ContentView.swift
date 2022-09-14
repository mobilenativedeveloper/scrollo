//
//  ContentView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI
import SwiftUICharts



struct ContentView: View {
    @State var isPresented: Bool = false
    
    var body: some View {
        Scrollo()
    }
}
//
//struct YourActivityViewTest: View {
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            HStack {
//                Button(action: {
//
//                }) {
//                    Image("circle_close")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 24, height: 24)
//                }
//                Spacer(minLength: 0)
//                Text("Ваша активность")
//                    .font(.system(size: 20))
//                    .fontWeight(.bold)
//                    .textCase(.uppercase)
//                    .foregroundColor(Color(hex: "#1F2128"))
//                Spacer(minLength: 0)
//                Button(action: {
//
//                }) {
//                    Color.clear
//                        .frame(width: 24, height: 24)
//                }
//            }
//            .padding(.bottom)
//            .padding(.horizontal)
//            Spacer()
//            VStack {
//                ScrollView {
//                    VStack(alignment: .leading) {
//                        Text("27 минут")
//                            .font(.custom(GothamBold, size: 20))
//                            .foregroundColor(.white)
//                            .padding(.bottom, 7)
//                        Text("Среднее время в день, которое вы проводите в Scrollo")
//                            .font(.custom(GothamBook, size: 12))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: 200)
//                    }
//                    .padding(.top, 21)
//                    .padding(.bottom, 19)
//                    .padding(.horizontal, 29)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .background(
//                        LinearGradient(colors: [Color(hex: "#5B86E5"), Color(hex: "#36DCD8")], startPoint: .leading, endPoint: .trailing)
//                    )
//                    .cornerRadius(10)
//                    .padding(.bottom, 28)
//                    .padding(.horizontal)
//                    ChartView(height: 213)
//
//                    HStack(spacing: 0) {
//                        Text("За эту неделю у вас")
//                            .font(.custom(GothamBold, size: 16))
//                            .foregroundColor(Color(hex: "#2E313C"))
//                            .padding(.bottom, 55)
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                    HStack(spacing: 0) {
//                        Text("Опубликовано медиа")
//                            .font(.custom(GothamBook, size: 14))
//                            .foregroundColor(Color(hex: "#898A8D"))
//                        Spacer()
//                        Text("1")
//                            .font(.custom(GothamBold, size: 14))
//                            .foregroundColor(.black)
//                    }
//                    .padding(.bottom, 32)
//                    .padding(.leading)
//                    .padding(.trailing, 79)
//                    HStack(spacing: 0) {
//                        Text("Написано постов")
//                            .font(.custom(GothamBook, size: 14))
//                            .foregroundColor(Color(hex: "#898A8D"))
//                        Spacer()
//                        Text("3")
//                            .font(.custom(GothamBold, size: 14))
//                            .foregroundColor(.black)
//                    }
//                    .padding(.bottom, 32)
//                    .padding(.leading)
//                    .padding(.trailing, 79)
//                    HStack(spacing: 0) {
//                        Text("Добавлено в сохраненное")
//                            .font(.custom(GothamBook, size: 14))
//                            .foregroundColor(Color(hex: "#898A8D"))
//                        Spacer()
//                        Text("2")
//                            .font(.custom(GothamBold, size: 14))
//                            .foregroundColor(.black)
//                    }
//                    .padding(.bottom, 32)
//                    .padding(.leading)
//                    .padding(.trailing, 79)
//                    HStack(spacing: 0) {
//                        Text("Подписчиков")
//                            .font(.custom(GothamBook, size: 14))
//                            .foregroundColor(Color(hex: "#898A8D"))
//                        Spacer()
//                        Text("12")
//                            .font(.custom(GothamBold, size: 14))
//                            .foregroundColor(.black)
//                    }
//                    .padding(.bottom, 32)
//                    .padding(.leading)
//                    .padding(.trailing, 79)
//                    HStack(spacing: 0) {
//                        Text("Подписок")
//                            .font(.custom(GothamBook, size: 14))
//                            .foregroundColor(Color(hex: "#898A8D"))
//                        Spacer()
//                        Text("15")
//                            .font(.custom(GothamBold, size: 14))
//                            .foregroundColor(.black)
//                    }
//                    .padding(.bottom, 32)
//                    .padding(.leading)
//                    .padding(.trailing, 79)
//                }
//            }
//        }
//        .ignoresSafeArea(.all, edges: .bottom)
//    }
//}
//
//

