//
//  CreateAccountViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/06/04.
//

import UIKit

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonLayout()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func tappedCreateButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

private extension CreateAccountViewController {
    func setButtonLayout() {
        let cornerRadius: CGFloat = 20
        
        createButton.layer.cornerRadius = cornerRadius
    }
}
