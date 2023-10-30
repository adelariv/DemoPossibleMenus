//
//  SideMenuCoordinator.swift
//  SideMenu
//
//  Created by Andres de la Riva Lamas on 30/10/23.
//

import Foundation
import UIKit

protocol SideMenuCoordinatorDelegate: AnyObject {
    func didSelect(menuItem: SideMenuItem)
}

final class SideMenuCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    init() {
        self.navigationController = UINavigationController(rootViewController: UIViewController())
    }

    func start() {
        let menuItems = getMenuItems()
        let homeViewController = HomeViewController()
        let sideMenuViewController = SideMenuViewController(sideMenuItems: menuItems)
        sideMenuViewController.delegate = self
        let containerViewController = ContainerViewController(sideMenuViewController: sideMenuViewController,
                                                              rootViewController: homeViewController)
        //containerViewController.showMenu()
        containerViewController.updateRootViewController(AboutViewController())
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [containerViewController]
    }

    private func getMenuItems() -> [SideMenuItem] {
        let homeViewController = HomeViewController()
        let settingsViewController = SettingsViewController()
        let aboutViewController = AboutViewController()
        let myAccountViewController = MyAccountViewController()
        let sideMenuItems = [
            SideMenuItem(icon: UIImage(systemName: "house.fill"),
                         title: "Home",
                         viewController: .embed(homeViewController)),
            SideMenuItem(icon: UIImage(systemName: "gear"),
                         title: "Settings",
                         viewController: .embed(settingsViewController)),
            SideMenuItem(icon: UIImage(systemName: "info.circle"),
                         title: "About",
                         viewController: .embed(aboutViewController)),
            SideMenuItem(icon: UIImage(systemName: "person"),
                         title: "My Account",
                         viewController: .embed(myAccountViewController))
        ]
        return sideMenuItems
    }
    
//    func makeContainer() -> ContainerViewController {
//        let homeViewController = HomeViewController()
//        let settingsViewController = SettingsViewController()
//        let aboutViewController = AboutViewController()
//        let myAccountViewController = MyAccountViewController()
//        let sideMenuItems = [
//            SideMenuItem(icon: UIImage(systemName: "house.fill"),
//                         title: "Home",
//                         viewController: .embed(homeViewController)),
//            SideMenuItem(icon: UIImage(systemName: "gear"),
//                         title: "Settings",
//                         viewController: .embed(settingsViewController)),
//            SideMenuItem(icon: UIImage(systemName: "info.circle"),
//                         title: "About",
//                         viewController: .push(aboutViewController)),
//            SideMenuItem(icon: UIImage(systemName: "person"),
//                         title: "My Account",
//                         viewController: .modal(myAccountViewController))
//        ]
//        let sideMenuViewController = SideMenuViewController(sideMenuItems: sideMenuItems)
//        let container = ContainerViewController(sideMenuViewController: sideMenuViewController,
//                                                rootViewController: homeViewController)
//
//        return container
//    }
}

extension SideMenuCoordinator: SideMenuCoordinatorDelegate {
    func didSelect(menuItem: SideMenuItem) {
        
    }
}

extension SideMenuCoordinator: SideMenuDelegate {
    func menuButtonTapped() {
        print("menuButtonTapped:::")
    }
    
    func itemSelected(item: ContentViewControllerPresentation) {
        print("Item::: \(item)")
    }
}
