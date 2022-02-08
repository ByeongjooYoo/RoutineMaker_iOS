//
//  AchievmentViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/06.
//

import UIKit

class AchievmentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
    }
}

private extension AchievmentViewController {
    func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
