//
//  LoginViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/06/03.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var findPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonsLayout()
        self.hideKeyboardWhenTappedAround()
    }
}

extension LoginViewController {
    func setButtonsLayout() {
        let cornerRadius: CGFloat = 20
        
        googleLoginButton.layer.cornerRadius = cornerRadius
        googleLoginButton.layer.borderWidth = 1
        googleLoginButton.layer.borderColor = UIColor.systemGray4.cgColor
        
        appleLoginButton.layer.cornerRadius = cornerRadius
        appleLoginButton.layer.borderWidth = 1
        appleLoginButton.layer.borderColor = UIColor.systemGray4.cgColor
        appleLoginButton.tintColor = UIColor.black
        
        emailLoginButton.layer.cornerRadius = cornerRadius
        
        findPasswordButton.layer.cornerRadius = cornerRadius
        findPasswordButton.layer.borderWidth = 1
        findPasswordButton.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
