//
//  LoginViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/06/03.
//

// TODO: Google 소셜 로그인
// TODO: Apple 로그인
// TODO: 이메일 로그인
// TODO: TextField 값 검증
// TODO: 로그인 성공 시 MainView로 전환 및 계정정보 넘기기(?)

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var googleLoginButton: HighlightButton!
    @IBOutlet weak var appleLoginButton: HighlightButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailLoginButton: HighlightButton!
    @IBOutlet weak var findPasswordButton: HighlightButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewLayout()
        setButtonsLayout()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func tappedemailLoginButton(_ sender: HighlightButton) {
        print("ButtonTest")
    }
    
    @IBAction func tappedFindPasswordButton(_ sender: HighlightButton) {
        print("ButtonTest")
    }
    
    
    @IBAction func tappedCreateAccountButton(_ sender: UIButton) {
        let createAccountViewController = CreateAccountViewController(nibName: "CreateAccountViewController", bundle: Bundle(for: CreateAccountViewController.self))
        createAccountViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(createAccountViewController, animated: true)
    }
}

extension LoginViewController {
    func setViewLayout() {
        navigationController?.isNavigationBarHidden = true
    }
    
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
        emailLoginButton.isEnabled = true
        
        findPasswordButton.layer.cornerRadius = cornerRadius
        findPasswordButton.layer.borderWidth = 1
        findPasswordButton.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
