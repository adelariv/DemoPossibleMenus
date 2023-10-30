//
//  SceneDelegate.swift
//  SideMenu
//
//  Created by Andres de la Riva Lamas on 30/10/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        //let navigationController = UINavigationController()
        let coordinator = SideMenuCoordinator()
        coordinator.start()
        
        window?.rootViewController = coordinator.navigationController
        window?.makeKeyAndVisible()
    }
}
