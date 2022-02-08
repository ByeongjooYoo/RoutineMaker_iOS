//
//  AddEventViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/07.
//

import UIKit

class AddEventViewController: UIViewController {
    @IBOutlet weak var eventInputStackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    @IBAction func tappedCancelBarButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

private extension AddEventViewController {
    func setLayout() {
        eventInputStackView.layer.cornerRadius = 10
        titleTextField.addLeftPadding(12)
        titleTextField.layer.cornerRadius = 10
        descriptionTextView.layer.cornerRadius = 10
    }
}
