//
//  TimeoutManager.swift
//  WrappersExamples
//
//  Created by Andres de la Riva Lamas on 17/06/2024.
//

import SwiftUI
import Combine

// Observable Object to manage the timeout
class TimeoutManager: ObservableObject {
    @Published var isActive = true
    private var timer: AnyCancellable?
    private let timeoutInterval: TimeInterval = 10 // 5 minutes

    init() {
        startTimer()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.publish(every: timeoutInterval, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.timeoutReached()
            }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    func resetTimer() {
        startTimer()
    }

    private func timeoutReached() {
        isActive = false
        let currentTime = Date().timeIntervalSince1970
        print("currentTime:::\(currentTime)")
        let lastTouchTime = (UIApplication.shared.currentWindow as? MobileWindow)?.lastTouchTime ?? 0
        print("lastTouchTime:::\(lastTouchTime)")
        let windowsTime = lastTouchTime + timeoutInterval
        print("windowsTime:::\(windowsTime)")
        if windowsTime < currentTime {
            print("Don't Logout User:::")
        } else {
            print("Logout User:::")
        }
        resetTimer()
    }
}

class MobileWindow: UIWindow {
    
    var lastTouchTime: TimeInterval = Date.now.timeIntervalSince1970
    
    override func sendEvent(_ event: UIEvent) {
        let newTouchTime = Date.now.timeIntervalSince1970
        if newTouchTime > lastTouchTime {
            lastTouchTime = newTouchTime
        }
        super.sendEvent(event)
    }
}

extension UIApplication {
    
    /// The app's key window.
    var keyWindowInConnectedScenes: UIWindow? {
//        let windowScenes: [UIWindowScene] = connectedScenes.compactMap({ $0 as? UIWindowScene })
//        let windows: [UIWindow] = windowScenes.flatMap({ $0.windows })
//        return windows.first(where: { $0.isKeyWindow })
        
//        let scenes = UIApplication.shared.connectedScenes
//        let windowScene = scenes.first as? UIWindowScene
//        let window = windowScene?.windows.first
        
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        return keyWindow
    }
    
    var keyWindow: UIWindow? {
            // Get connected scenes
            return self.connectedScenes
                // Keep only active scenes, onscreen and visible to the user
                .filter { $0.activationState == .foregroundActive }
                // Keep only the first `UIWindowScene`
                .first(where: { $0 is UIWindowScene })
                // Get its associated windows
                .flatMap({ $0 as? UIWindowScene })?.windows
                // Finally, keep only the key window
                .first(where: \.isKeyWindow)
        }
    
    var currentWindow: UIWindow? {
            connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        }
}


// Custom view to capture user interactions
struct InteractionCapturingView<Content: View>: View {
    @EnvironmentObject var timeoutManager: TimeoutManager
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(InteractionCapture())
    }

    private struct InteractionCapture: UIViewRepresentable {
        @EnvironmentObject var timeoutManager: TimeoutManager

        func makeUIView(context: Context) -> UIView {
            let view = UIView()
            let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.resetTimer))
            let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.resetTimer))
            let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.resetTimer))
            let swipeGesture = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.resetTimer))

            view.addGestureRecognizer(tapGesture)
            view.addGestureRecognizer(panGesture)
            view.addGestureRecognizer(pinchGesture)
            view.addGestureRecognizer(swipeGesture)

            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) {}

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject {
            var parent: InteractionCapture

            init(_ parent: InteractionCapture) {
                self.parent = parent
            }

            @objc func resetTimer() {
                parent.timeoutManager.resetTimer()
            }
        }
    }
}


