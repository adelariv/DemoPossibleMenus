//
//  ContainerViewController.swift
//  SideMenu
//
//  Created by Andres de la Riva Lamas on 30/10/23.
//

import UIKit

final class ContainerViewController: UIViewController {
    private var sideMenuViewController: SideMenuViewController!
    private var navigator: UINavigationController!
    private var rootViewController: UIViewController! {
        didSet {
//            rootViewController.delegate = self
            navigator.setViewControllers([rootViewController], animated: false)
        }
    }

    convenience init(sideMenuViewController: SideMenuViewController, rootViewController: UIViewController) {
        self.init()
        self.sideMenuViewController = sideMenuViewController
        self.rootViewController = rootViewController
        self.navigator = UINavigationController(rootViewController: rootViewController)
    }
    
//    public getNavigator

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    public func showMenu() {
        sideMenuViewController.show()
    }
    
    public func hideMenu() {
        sideMenuViewController.show()
    }

    private func configureView() {
        addChildViewControllers()
        configureDelegates()
        configureGestures()
    }

    private func configureDelegates() {
//        sideMenuViewController.delegate = self.delegate
//        rootViewController.delegate = self
    }

    private func configureGestures() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeftGesture.direction = .left
        swipeLeftGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeLeftGesture)

        let rightSwipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipedRight))
        rightSwipeGesture.cancelsTouchesInView = false
        rightSwipeGesture.edges = .left
        view.addGestureRecognizer(rightSwipeGesture)
    }

    @objc private func swipedLeft() {
        sideMenuViewController.hide()
    }

    @objc private func swipedRight() {
        sideMenuViewController.show()
    }

    func updateRootViewController(_ viewController: UIViewController) {
        rootViewController = viewController
    }

    private func addChildViewControllers() {
        addChild(navigator)
        view.addSubview(navigator.view)
        navigator.didMove(toParent: self)

        addChild(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)
    }
}

extension ContainerViewController: SideMenuDelegate {
    func menuButtonTapped() {
        sideMenuViewController.show()
    }

    func itemSelected(item: ContentViewControllerPresentation) {
        switch item {
        case let .embed(viewController):
            updateRootViewController(viewController)
            sideMenuViewController.hide()
        case let .push(viewController):
            sideMenuViewController.hide()
            navigator.pushViewController(viewController, animated: true)
        case let .modal(viewController):
            sideMenuViewController.hide()
            navigator.present(viewController, animated: true, completion: nil)
        }
    }
}