//
//  UIBottomSheetView.swift
//  scrollo
//
//  Created by Artem Strelnik on 05.07.2022.
//

import SwiftUI

#if !os(macOS)
public struct BottomSheet<Content: View>: View {
    
    private var dragToDismissThreshold: CGFloat { height * 0.2 }
    private var grayBackgroundOpacity: Double { isPresented ? (0.4 - Double(draggedOffset)/600) : 0 }
    
    @State private var draggedOffset: CGFloat = 0
    @State private var previousDragValue: DragGesture.Value?

    @Binding var isPresented: Bool
    private let height: CGFloat
    private let topBarHeight: CGFloat
    private let topBarCornerRadius: CGFloat
    private let content: Content
    private let contentBackgroundColor: Color
    private let topBarBackgroundColor: Color
    private let showTopIndicator: Bool
    private let corners: Bool
    public init(
        isPresented: Binding<Bool>,
        height: CGFloat,
        topBarHeight: CGFloat = 20,
        topBarCornerRadius: CGFloat? = nil,
        topBarBackgroundColor: Color = Color(.systemBackground),
        contentBackgroundColor: Color = Color(.systemBackground),
        showTopIndicator: Bool,
        corners: Bool,
        @ViewBuilder content: () -> Content
    ) {
        self.topBarBackgroundColor = topBarBackgroundColor
        self.contentBackgroundColor = contentBackgroundColor
        self._isPresented = isPresented
        self.height = height
        self.topBarHeight = topBarHeight
        if let topBarCornerRadius = topBarCornerRadius {
            self.topBarCornerRadius = topBarCornerRadius
        } else {
            self.topBarCornerRadius = topBarHeight / 3
        }
        self.showTopIndicator = showTopIndicator
        self.corners = corners
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.fullScreenLightGrayOverlay()
                VStack(spacing: 0) {
                    self.topBar(geometry: geometry)
                    VStack(spacing: 0) {
                        Spacer()
                        self.content.padding(.bottom, geometry.safeAreaInsets.bottom)
                        Spacer()
                    }
                }
                .frame(width: self.corners ? UIScreen.main.bounds.width - 30 : nil, height: sheetHeight(in: geometry) - min(self.draggedOffset*2, 0))
                .background(self.contentBackgroundColor)
                .cornerRadius(self.topBarCornerRadius, corners: !self.corners ? [.topLeft, .topRight] : .allCorners)
                .animation(.interactiveSpring())
                .offset(y: self.isPresented ? (geometry.size.height/2 - sheetHeight(in: geometry)/2 + geometry.safeAreaInsets.bottom + self.draggedOffset) - (self.corners ? 35 : 0) : (geometry.size.height/2 + sheetHeight(in: geometry)/2 + geometry.safeAreaInsets.bottom))
            }
        }
    }
    
    fileprivate func sheetHeight(in geometry: GeometryProxy) -> CGFloat {
        return min(height, geometry.size.height)
    }
    
    fileprivate func fullScreenLightGrayOverlay() -> some View {
        Color
            .black
            .opacity(grayBackgroundOpacity)
            .edgesIgnoringSafeArea(.all)
            .animation(.interactiveSpring())
            .onTapGesture { self.isPresented = false }
    }
    
    fileprivate func topBar(geometry: GeometryProxy) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "F2F2F2"))
                .frame(width: 40, height: 6)
                .opacity(showTopIndicator ? 1 : 0)
        }
        .frame(width: geometry.size.width, height: topBarHeight)
        .background(topBarBackgroundColor)
        .gesture(
            DragGesture()
                .onChanged({ (value) in
                    // ignore gestures while the sheet is hidden. Otherwise it could collide with the iOS-global "go to home screen"-gesture
                    guard isPresented else { return }

                    let offsetY = value.translation.height
                    self.draggedOffset = offsetY
                    
                    if let previousValue = self.previousDragValue {
                        let previousOffsetY = previousValue.translation.height
                        let timeDiff = Double(value.time.timeIntervalSince(previousValue.time))
                        let heightDiff = Double(offsetY - previousOffsetY)
                        let velocityY = heightDiff / timeDiff
                        if velocityY > 1400 {
                            self.isPresented = false
                            return
                        }
                    }
                    self.previousDragValue = value
                    
                })
                .onEnded({ (value) in
                    let offsetY = value.translation.height
                    if offsetY > self.dragToDismissThreshold {
                        self.isPresented = false
                    }
                    self.draggedOffset = 0
                })
        )
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

public extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: CGFloat,
        topBarHeight: CGFloat = 30,
        topBarCornerRadius: CGFloat? = nil,
        contentBackgroundColor: Color = Color(.systemBackground),
        topBarBackgroundColor: Color = Color(.systemBackground),
        showTopIndicator: Bool = true,
        corners: Bool,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            BottomSheet(isPresented: isPresented,
                        height: height,
                        topBarHeight: topBarHeight,
                        topBarCornerRadius: topBarCornerRadius,
                        topBarBackgroundColor: topBarBackgroundColor,
                        contentBackgroundColor: contentBackgroundColor,
                        showTopIndicator: showTopIndicator,
                        corners: corners,
                        content: content)
        }
    }

    func bottomSheet<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        height: CGFloat,
        topBarHeight: CGFloat = 30,
        topBarCornerRadius: CGFloat? = nil,
        contentBackgroundColor: Color = Color(.systemBackground),
        topBarBackgroundColor: Color = Color(.systemBackground),
        showTopIndicator: Bool = true,
        corners: Bool = false,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        let isPresented = Binding {
            item.wrappedValue != nil
        } set: { value in
            if !value {
                item.wrappedValue = nil
            }
        }
        
        return bottomSheet(
            isPresented: isPresented,
            height: height,
            topBarHeight: topBarHeight,
            topBarCornerRadius: topBarCornerRadius,
            contentBackgroundColor: contentBackgroundColor,
            topBarBackgroundColor: topBarBackgroundColor,
            showTopIndicator: showTopIndicator,
            corners: corners
        ) {
            if let unwrapedItem = item.wrappedValue {
                content(unwrapedItem)
            } else {
                EmptyView()
            }
        }
    }
}
#endif
