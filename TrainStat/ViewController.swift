//
//  ViewController.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 26.10.2024.
//

import UIKit
import SwiftUI
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue

        let mainTabView = MainTabView()
        let hostingController = UIHostingController(rootView: mainTabView)

        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        hostingController.didMove(toParent: self)
    }
}

