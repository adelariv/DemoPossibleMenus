//
//  ContentViewControllerPresentation.swift
//  SideMenu
//
//  Created by Andres de la Riva Lamas on 30/10/23.
//

import UIKit

enum ContentViewControllerPresentation {
    case embed(UIViewController) //case embed(ContentViewController)
    case push(UIViewController)
    case modal(UIViewController)
}
