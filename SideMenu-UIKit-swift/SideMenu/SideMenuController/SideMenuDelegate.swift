//
//  SideMenuDelegate.swift
//  SideMenu
//
//  Created by Andres de la Riva Lamas on 30/10/23.
//

import Foundation

protocol SideMenuDelegate: AnyObject {
    func menuButtonTapped()
    func itemSelected(item: ContentViewControllerPresentation)
}
