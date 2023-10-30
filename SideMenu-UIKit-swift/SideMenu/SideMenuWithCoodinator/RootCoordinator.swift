//
//  RootCoordinator.swift
//  SideMenu
//
//  Created by Andres de la Riva Lamas on 30/10/23.
//

import Foundation

protocol Coordinator: AnyObject {
    func start()
}

final class RootCoordinator {
    var current: Coordinator?
}

