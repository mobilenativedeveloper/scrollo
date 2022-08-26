//
//  PullToRefresh.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//
import SwiftUI


private enum PositionType {
  case fixed, moving
}

private struct Position: Equatable {
  let type: PositionType
  let y: CGFloat
}

private struct PositionPreferenceKey: PreferenceKey {
  typealias Value = [Position]

  static var defaultValue = [Position]()

  static func reduce(value: inout [Position], nextValue: () -> [Position]) {
    value.append(contentsOf: nextValue())
  }
}

private struct PositionIndicator: View {
  let type: PositionType

  var body: some View {
    GeometryReader { proxy in
        // the View itself is an invisible Shape that fills as much as possible
        Color.clear
          // Compute the top Y position and emit it to the Preferences queue
          .preference(key: PositionPreferenceKey.self, value: [Position(type: type, y: proxy.frame(in: .global).minY)])
     }
  }
}

public typealias RefreshComplete = () -> Void

public typealias OnRefresh = (@escaping RefreshComplete) -> Void

public let defaultRefreshThreshold: CGFloat = 68

public enum RefreshState {
  case waiting, primed, loading
}

public typealias RefreshProgressBuilder<Progress: View> = (RefreshState) -> Progress

public let defaultLoadingViewBackgroundColor = Color(hex: "#F9F9F9")


public struct RefreshableScrollView<Progress, Content>: View where Progress: View, Content: View {
  let showsIndicators: Bool // if the ScrollView should show indicators
  let loadingViewBackgroundColor: Color
  let threshold: CGFloat // what height do you have to pull down to trigger the refresh
  let onRefresh: OnRefresh // the refreshing action
  let progress: RefreshProgressBuilder<Progress> // custom progress view
  let content: () -> Content // the ScrollView content
  @State private var offset: CGFloat = 0
  @State private var state = RefreshState.waiting // the current state
    
    // Haptic Feedback
    let pullReleasedFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

  // We use a custom constructor to allow for usage of a @ViewBuilder for the content
  public init(showsIndicators: Bool = true,
              loadingViewBackgroundColor: Color = defaultLoadingViewBackgroundColor,
              threshold: CGFloat = defaultRefreshThreshold,
              onRefresh: @escaping OnRefresh,
              @ViewBuilder progress: @escaping RefreshProgressBuilder<Progress>,
              @ViewBuilder content: @escaping () -> Content) {
    self.showsIndicators = showsIndicators
    self.loadingViewBackgroundColor = loadingViewBackgroundColor
    self.threshold = threshold
    self.onRefresh = onRefresh
    self.progress = progress
    self.content = content
  }

  public var body: some View {
    // The root view is a regular ScrollView
    ScrollView(showsIndicators: showsIndicators) {
      // The ZStack allows us to position the PositionIndicator,
      // the content and the loading view, all on top of each other.
      ZStack(alignment: .top) {
        // The moving positioning indicator, that sits at the top
        // of the ScrollView and scrolls down with the content
        PositionIndicator(type: .moving)
          .frame(height: 0)

         // Your ScrollView content. If we're loading, we want
         // to keep it below the loading view, hence the alignmentGuide.
         content()
           .alignmentGuide(.top, computeValue: { _ in
             (state == .loading) ? -threshold + max(0, offset) : 0
            })

          // The loading view. It's offset to the top of the content unless we're loading.
          ZStack {
            Rectangle()
              .foregroundColor(loadingViewBackgroundColor)
              .frame(height: threshold)
            progress(state)
          }.offset(y: (state == .loading) ? -max(0, offset) : -threshold)
        }
      }
      // Put a fixed PositionIndicator in the background so that we have
      // a reference point to compute the scroll offset.
      .background(PositionIndicator(type: .fixed))
      // Once the scrolling offset changes, we want to see if there should
      // be a state change.
      .onPreferenceChange(PositionPreferenceKey.self) { values in
        // Compute the offset between the moving and fixed PositionIndicators
        let movingY = values.first { $0.type == .moving }?.y ?? 0
        let fixedY = values.first { $0.type == .fixed }?.y ?? 0
        offset = movingY - fixedY
        if state != .loading { // If we're already loading, ignore everything
          // Map the preference change action to the UI thread
          DispatchQueue.main.async {
            

            // If the user pulled down below the threshold, prime the view
            if offset > threshold && state == .waiting {
              state = .primed

            // If the view is primed and we've crossed the threshold again on the
            // way back, trigger the refresh
            } else if offset < threshold && state == .primed {
              state = .loading
              self.pullReleasedFeedbackGenerator.impactOccurred()
              onRefresh { // trigger the refreshing callback
                // once refreshing is done, smoothly move the loading view
                // back to the offset position
                withAnimation {
                  self.state = .waiting
                }
              }
            }
          }
        }
      }
  }
}

public extension RefreshableScrollView where Progress == RefreshActivityIndicator {
    init(showsIndicators: Bool = true,
         loadingViewBackgroundColor: Color = defaultLoadingViewBackgroundColor,
         threshold: CGFloat = defaultRefreshThreshold,
         onRefresh: @escaping OnRefresh,
         @ViewBuilder content: @escaping () -> Content) {
        self.init(showsIndicators: showsIndicators,
                  loadingViewBackgroundColor: loadingViewBackgroundColor,
                  threshold: threshold,
                  onRefresh: onRefresh,
                  progress: { state in
                    RefreshActivityIndicator(isAnimating: state == .loading) {
                        $0.hidesWhenStopped = false
                    }
                 },
                 content: content)
    }
}


public struct RefreshActivityIndicator: UIViewRepresentable {
  public typealias UIView = UIActivityIndicatorView
  public var isAnimating: Bool = true
  public var configuration = { (indicator: UIView) in }

  public init(isAnimating: Bool, configuration: ((UIView) -> Void)? = nil) {
    self.isAnimating = isAnimating
    if let configuration = configuration {
      self.configuration = configuration
    }
  }

  public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView {
    UIView()
  }

  public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
    isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    configuration(uiView)
  }
}


#if compiler(>=5.5)
// Allows using RefreshableScrollView with an async block.
@available(iOS 15.0, *)
public extension RefreshableScrollView {
    init(showsIndicators: Bool = true,
         loadingViewBackgroundColor: Color = defaultLoadingViewBackgroundColor,
         threshold: CGFloat = defaultRefreshThreshold,
         action: @escaping @Sendable () async -> Void,
         @ViewBuilder progress: @escaping RefreshProgressBuilder<Progress>,
         @ViewBuilder content: @escaping () -> Content) {
        self.init(showsIndicators: showsIndicators,
                  loadingViewBackgroundColor: loadingViewBackgroundColor,
                  threshold: threshold,
                  onRefresh: { refreshComplete in
                    Task {
                        await action()
                        refreshComplete()
                    }
                },
                  progress: progress,
                  content: content)
    }
}
#endif

public struct RefreshableCompat<Progress>: ViewModifier where Progress: View {
    private let showsIndicators: Bool
    private let loadingViewBackgroundColor: Color
    private let threshold: CGFloat
    private let onRefresh: OnRefresh
    private let progress: RefreshProgressBuilder<Progress>
    
    public init(showsIndicators: Bool = true,
                loadingViewBackgroundColor: Color = defaultLoadingViewBackgroundColor,
                threshold: CGFloat = defaultRefreshThreshold,
                onRefresh: @escaping OnRefresh,
                @ViewBuilder progress: @escaping RefreshProgressBuilder<Progress>) {
        self.showsIndicators = showsIndicators
        self.loadingViewBackgroundColor = loadingViewBackgroundColor
        self.threshold = threshold
        self.onRefresh = onRefresh
        self.progress = progress
    }
    
    public func body(content: Content) -> some View {
        RefreshableScrollView(showsIndicators: showsIndicators,
                              loadingViewBackgroundColor: loadingViewBackgroundColor,
                              threshold: threshold,
                              onRefresh: onRefresh,
                              progress: progress) {
            content
        }
    }
}

#if compiler(>=5.5)
@available(iOS 15.0, *)
public extension List {
    @ViewBuilder func refreshableCompat<Progress: View>(showsIndicators: Bool = true,
                                                        loadingViewBackgroundColor: Color = defaultLoadingViewBackgroundColor,
                                                        threshold: CGFloat = defaultRefreshThreshold,
                                                        onRefresh: @escaping OnRefresh,
                                                        @ViewBuilder progress: @escaping RefreshProgressBuilder<Progress>) -> some View {
        if #available(iOS 15.0, macOS 12.0, *) {
            self.refreshable {
                await withCheckedContinuation { cont in
                    onRefresh {
                        cont.resume()
                    }
                }
            }
        } else {
            self.modifier(RefreshableCompat(showsIndicators: showsIndicators,
                                            loadingViewBackgroundColor: loadingViewBackgroundColor,
                                            threshold: threshold,
                                            onRefresh: onRefresh,
                                            progress: progress))
        }
    }
}
#endif

public extension View {
    @ViewBuilder func refreshableCompat<Progress: View>(showsIndicators: Bool = true,
                                                        loadingViewBackgroundColor: Color = defaultLoadingViewBackgroundColor,
                                                        threshold: CGFloat = defaultRefreshThreshold,
                                                        onRefresh: @escaping OnRefresh,
                                                        @ViewBuilder progress: @escaping RefreshProgressBuilder<Progress>) -> some View {
        self.modifier(RefreshableCompat(showsIndicators: showsIndicators,
                                        loadingViewBackgroundColor: loadingViewBackgroundColor,
                                        threshold: threshold,
                                        onRefresh: onRefresh,
                                        progress: progress))
    }
}
