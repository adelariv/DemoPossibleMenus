//
//  WrappersExamplesApp.swift
//  WrappersExamples
//
//  Created by Andres de la Riva Lamas on 3/03/24.
//

import SwiftUI
import UIKit

enum AppView: Equatable {
    case welcome
    case other(id: UUID, viewController: UIViewController)
    case swiftUIView(id: UUID, view: AnyView)
    
    static func == (lhs: AppView, rhs: AppView) -> Bool {
        switch (lhs, rhs) {
        case (.welcome, .welcome):
            return true
        case (.other(let lhsID, _), .other(let rhsID, _)):
            return lhsID == rhsID
        case (.swiftUIView(let lhsID, _), .swiftUIView(let rhsID, _)):
            return lhsID == rhsID
        default:
            return false
        }
    }
}

@main
struct WrappersExamplesApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegateAdapter.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate)
        }
    }
}

//struct ContentView: View {
//    @EnvironmentObject var appDelegate: AppDelegateAdapter
//    
//    var body: some View {
//        Group {
//            appDelegate.currentView ?? AnyView(EmptyView()) // Display the current view or an empty view if currentView is nil
//        }
//    }
//}

struct ContentView: View {
    @EnvironmentObject var appDelegate: AppDelegateAdapter
    
    var body: some View {
        Group {
            switch appDelegate.currentView {
            case .welcome:
                ContentViewWrapper(viewController: appDelegate.getMainVC())
            case .other(_, let viewController):
                ContentViewWrapper(viewController: viewController)
            case .swiftUIView(_, let swiftUIView):
                swiftUIView
            case .none:
                EmptyView()
            }
        }
        .transition(.slide)
        .animation(.easeInOut, value: appDelegate.currentView)
    }
}



class AppDelegateAdapter: NSObject, UIApplicationDelegate, ObservableObject {
    
    static private(set) var instance: AppDelegateAdapter? = nil
    var rootCoordiantor: RootCoordinator?
    @Published var currentView: AppView?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppDelegateAdapter.instance = self
        
        self.rootCoordiantor = RootCoordinator()
        
//        let welcomeVC = getWelcomeVC()
//        currentView = AnyView(ContentViewWrapper(viewController: welcomeVC))
       
        currentView = .welcome
        
//        currentView = .swiftUIView(id: UUID(), view: AnyView(TestView().environmentObject(self)))
        return true
    }
    
    func swapScreen(_ viewController: UIViewController) {
        withAnimation(.easeOut(duration: 0.5)) {
            currentView = .other(id: UUID(), viewController: viewController)
            print("SwapScreen::: Screen swapped to UIViewController")
        }
    }
    
    func swapScreen<V: View>(_ swiftUIView: V) {
        withAnimation(.easeOut(duration: 0.5)) {
            currentView = .swiftUIView(id: UUID(), view: AnyView(swiftUIView))
            print("SwapScreen::: Screen swapped to SwiftUI View")
        }
    }
    
    func getMainVC() -> UIViewController {
        let mainVC = UIViewController()
        mainVC.view.backgroundColor = .green
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Swap to Second screen", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(showSecond), for: .touchUpInside)
        mainVC.view.addSubview(button)
        button.topAnchor.constraint(equalTo: mainVC.view.topAnchor, constant: 40).isActive = true
        button.leadingAnchor.constraint(equalTo: mainVC.view.leadingAnchor, constant: 100).isActive = true
        
        return mainVC
    }
    
    @objc
    func showSecond() {
        let secondVC = UIViewController()
        secondVC.view.backgroundColor = .purple
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("goWelcomeScreen", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(goWelcomeScreen), for: .touchUpInside)
        secondVC.view.addSubview(button)
        button.topAnchor.constraint(equalTo: secondVC.view.topAnchor, constant: 40).isActive = true
        button.leadingAnchor.constraint(equalTo: secondVC.view.leadingAnchor, constant: 100).isActive = true
        
        let buttonUIVIew = UIButton(type: .system)
        buttonUIVIew.translatesAutoresizingMaskIntoConstraints = false
        buttonUIVIew.setTitle("showNewSwiftUIView", for: .normal)
        buttonUIVIew.backgroundColor = .red
        buttonUIVIew.addTarget(self, action: #selector(showNewSwiftUIView), for: .touchUpInside)
        secondVC.view.addSubview(buttonUIVIew)
        buttonUIVIew.topAnchor.constraint(equalTo: secondVC.view.topAnchor, constant: 140).isActive = true
        buttonUIVIew.leadingAnchor.constraint(equalTo: secondVC.view.leadingAnchor, constant: 200).isActive = true
        
        swapScreen(secondVC)
    }
    
    @objc
    func goWelcomeScreen() {
        currentView = .welcome

    }

    @objc
    func showNewSwiftUIView() {
        let newSwiftUIView = Text("New SwiftUI View").background(Color.blue)
        swapScreen(newSwiftUIView)
    }
}

extension AppDelegateAdapter {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = SceneDelegate.self
        }
        return configuration
    }
}


final class SceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
    }
}

protocol Coordinator: AnyObject {
    func start()
}

final class RootCoordinator: NSObject {
    var current: Coordinator?
}


class HostingController<Content: View>: UIHostingController<Content> {
    required override init(rootView: Content) {
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ContentViewWrapper: UIViewControllerRepresentable {
    var viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

//struct ContentViewWrapper<ViewControllerType: UIViewController>: UIViewControllerRepresentable {
//    let viewController: ViewControllerType
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        
//    }
//}

struct TestView: View {
    @EnvironmentObject var appDelegate: AppDelegateAdapter
    
    var body: some View {
        VStack {
            Text("Current View")
            Button("Swap to New View") {
                let newVC = appDelegate.getMainVC()// Replace with your actual new view controller
                newVC.view.backgroundColor = .red // Just for testing visibility
                appDelegate.swapScreen(newVC)
            }
            Button("Swap to SwiftUI View") {
                let newSwiftUIView = Text("New SwiftUI View").background(Color.blue)
                appDelegate.swapScreen(newSwiftUIView)
            }
        }
    }
}


//    func swapScreen(_ viewController: UIViewController) {
//        objectWillChange.send()
//        let contentView = ContentViewWrapper(viewController: viewController)
//        withAnimation(.easeOut(duration: 0.5)) {
//            currentView?.opacity(0)
//            currentView = AnyView(contentView.transition(.slide))
//            print("SwapScreen:::")
//        }
//    }
