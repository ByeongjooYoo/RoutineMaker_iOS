//
//  AchievmentViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/06.
//

import UIKit

class AchievmentViewController: UIViewController {
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayAchivmentProgressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupDayViewLayout()
    }
}

private extension AchievmentViewController {
    func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupDayViewLayout() {
        dayView.layer.cornerRadius = 10
        dayAchivmentProgressView.layer.cornerRadius = 8
    }
}
