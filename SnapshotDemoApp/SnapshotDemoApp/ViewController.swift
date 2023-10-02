//
//  ViewController.swift
//  SnapshotDemoApp
//
//  Created by Andres de la Riva Lamas on 2/10/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange

                let label = UILabel()
                label.text = "Hello World"
                label.textColor = .black
                label.font = .systemFont(ofSize: 32)
                label.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(label)

                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ])
    }


}

