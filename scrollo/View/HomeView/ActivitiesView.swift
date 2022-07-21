//
//  ActivitiesView.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

struct ActivitiesView: View {
    @State private var selection: String = "Вы"
    private let tabs: [String] = ["Вы", "Запросы"]
    
    var body: some View {
        VStack {
            self.tabsHeader()
            VStack {
                TabView(selection: self.$selection) {
                    List {
                        
                        HStack {
                            Text("сегодня")
                                .font(.system(size: 18))
                                .bold()
                                .textCase(.uppercase)
                                .foregroundColor(Color(hex: "#2E313C"))
                                .padding(.top, 16)
                                .padding(.bottom, 18)
                                .padding(.horizontal, 19)
                            Spacer()
                        }
                        .ignoreListAppearance()
                        
                        VStack(spacing: 0) {
                            
                            HStack(spacing: 0) {
                                
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                                    .padding(.trailing, 16)
                                
                                Group {
                                    Text("krisi_shestud").font(.custom(GothamBold, size: 14)) + Text(" ") + Text("подписалась на вас").font(.custom(GothamBook, size: 12)).foregroundColor(Color(hex: "#2E313C")) + Text(" ") + Text("10мин").font(.custom(GothamBold, size: 12)).foregroundColor(Color(hex: "#828796"))
                                }
                                .padding(.trailing, 11)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("Подписаться").font(.custom(GothamBold, size: 10)).foregroundColor(.white)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color(hex: "#5B86E5"))
                                .cornerRadius(9)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            
                            HStack(spacing: 0) {
                                
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                                    .padding(.trailing, 16)
                                
                                Group {
                                    Text("Meri_smith").font(.custom(GothamBold, size: 14)) + Text(" ") + Text("нравится ваше фото").font(.custom(GothamBook, size: 12)).foregroundColor(Color(hex: "#2E313C")) + Text(" ") + Text("10мин").font(.custom(GothamBold, size: 12)).foregroundColor(Color(hex: "#828796"))
                                }
                                .padding(.trailing, 11)
                                
                                Spacer()
                                
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                            .background(Color(hex: "#F9F9F9"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            HStack(spacing: 0) {
                                
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                                    .padding(.trailing, 16)
                                
                                Group {
                                    Text("lea_mish, katy_loui").font(.custom(GothamBold, size: 14)) + Text(" ") + Text("и 123 человека нравится ваше фото").font(.custom(GothamBook, size: 12)).foregroundColor(Color(hex: "#2E313C")) + Text(" ") + Text("34мин").font(.custom(GothamBold, size: 12)).foregroundColor(Color(hex: "#828796"))
                                }
                                .padding(.trailing, 11)
                                
                                Spacer()
                                
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                            .background(Color(hex: "#F9F9F9"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            HStack(spacing: 0) {
                                
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                                    .padding(.trailing, 16)
                                
                                Group {
                                    Text("flin_rosko").font(.custom(GothamBold, size: 14)) + Text(" ") + Text("подписалась на вас").font(.custom(GothamBook, size: 12)).foregroundColor(Color(hex: "#2E313C")) + Text(" ") + Text("6д").font(.custom(GothamBold, size: 12)).foregroundColor(Color(hex: "#828796"))
                                }
                                .padding(.trailing, 11)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("Написать").font(.custom(GothamBold, size: 10)).foregroundColor(Color(hex: "#444A5E"))
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 9)
                                        .stroke(Color(hex: "#DDE8E8"), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                        }
                        .padding(.horizontal)
                        .ignoreListAppearance()
                        
                        HStack {
                            Text("эта неделя")
                                .font(.system(size: 18))
                                .bold()
                                .textCase(.uppercase)
                                .foregroundColor(Color(hex: "#2E313C"))
                                .padding(.top, 16)
                                .padding(.bottom, 18)
                                .padding(.horizontal, 19)
                            Spacer()
                        }
                        .ignoreListAppearance()
                        
                        VStack(spacing: 0) {
                            
                            HStack(spacing: 0) {
                                
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                                    .padding(.trailing, 16)
                                
                                Group {
                                    Text("krisi_shestud").font(.custom(GothamBold, size: 14)) + Text(" ") + Text("подписалась на вас").font(.custom(GothamBook, size: 12)).foregroundColor(Color(hex: "#2E313C")) + Text(" ") + Text("10мин").font(.custom(GothamBold, size: 12)).foregroundColor(Color(hex: "#828796"))
                                }
                                .padding(.trailing, 11)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("Подписаться").font(.custom(GothamBold, size: 10)).foregroundColor(.white)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color(hex: "#5B86E5"))
                                .cornerRadius(9)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            
                            HStack(spacing: 0) {
                                
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                                    .padding(.trailing, 16)
                                
                                Group {
                                    Text("Meri_smith").font(.custom(GothamBold, size: 14)) + Text(" ") + Text("нравится ваше фото").font(.custom(GothamBook, size: 12)).foregroundColor(Color(hex: "#2E313C")) + Text(" ") + Text("10мин").font(.custom(GothamBold, size: 12)).foregroundColor(Color(hex: "#828796"))
                                }
                                .padding(.trailing, 11)
                                
                                Spacer()
                                
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                            .background(Color(hex: "#F9F9F9"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            HStack(spacing: 0) {
                                
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                                    .padding(.trailing, 16)
                                
                                Group {
                                    Text("lea_mish, katy_loui").font(.custom(GothamBold, size: 14)) + Text(" ") + Text("и 123 человека нравится ваше фото").font(.custom(GothamBook, size: 12)).foregroundColor(Color(hex: "#2E313C")) + Text(" ") + Text("34мин").font(.custom(GothamBold, size: 12)).foregroundColor(Color(hex: "#828796"))
                                }
                                .padding(.trailing, 11)
                                
                                Spacer()
                                
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                            .background(Color(hex: "#F9F9F9"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            HStack(spacing: 0) {
                                
                                Image("testUserPhoto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                                    .padding(.trailing, 16)
                                
                                Group {
                                    Text("flin_rosko").font(.custom(GothamBold, size: 14)) + Text(" ") + Text("подписалась на вас").font(.custom(GothamBook, size: 12)).foregroundColor(Color(hex: "#2E313C")) + Text(" ") + Text("6д").font(.custom(GothamBold, size: 12)).foregroundColor(Color(hex: "#828796"))
                                }
                                .padding(.trailing, 11)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("Написать").font(.custom(GothamBold, size: 10)).foregroundColor(Color(hex: "#444A5E"))
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 9)
                                        .stroke(Color(hex: "#DDE8E8"), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                        .ignoreListAppearance()
                    }
                    .listStyle(.plain)
                    .tag("Вы")
                    
                    ScrollView(showsIndicators: false) {
                        
                    }.tag("Запросы")
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: Alignment(horizontal: .leading, vertical: .top))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: Alignment(horizontal: .leading, vertical: .top))
        .background(Color(hex: "#F9F9F9").ignoresSafeArea(.all))
        
    }
    
    @ViewBuilder
    private func tabsHeader() -> some View {
        HStack(spacing: 0) {
            ForEach(0..<self.tabs.count, id: \.self) {index in
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    Button(action: {
                        withAnimation(.default) {
                            self.selection = self.tabs[index]
                        }
                    }) {
                        Text(self.tabs[index])
                            .font(.custom(self.selection == self.tabs[index] ? GothamBold : GothamBook, size: 13))
                            .textCase(.uppercase)
                            .foregroundColor(Color(hex: self.selection == self.tabs[index] ? "#5B86E5" :  "#333333"))
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / CGFloat(self.tabs.count) - 32))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "#5B86E5").opacity(self.selection == self.tabs[index] ? 1 : 0))
                        .frame(width: (UIScreen.main.bounds.width / CGFloat(self.tabs.count) - 32), height: 3)
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
    
    
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
    }
}
