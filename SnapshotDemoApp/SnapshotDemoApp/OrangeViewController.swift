//
//  OrangeViewController.swift
//  SnapshotDemoApp
//
//  Created by Andres de la Riva Lamas on 2/10/23.
//

import Foundation
import UIKit

public final class OrangeViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange

                let label = UILabel()
                label.text = "Orange Screen"
                label.textColor = .black
                label.font = .systemFont(ofSize: 32)
                label.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(label)

                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ])
    }
    
    public func getButton() -> UIButton {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 200) )
        btn.setTitle("Click Me", for: .normal)
        return btn
    }
}
