//
//  CreateAccountViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/06/04.
//

// TODO: 입력된 email 검증하는 함수
// TODO: 입력된 password 검증하는 함수
// TODO: 오류 발생 시 emailErrorLabel에 Error message 표시하는 함수
// TODO: 오류 발생 시 passwordErrorLabel에 Error message 표시하는 함수
// TODO: Firebase에 CreateUser 요청하는 함수
// TODO: Create 성공시 pop, 실패 시 error를 표시하고 현재화면 유지


import UIKit

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var createButton: HighlightButton!
    
    private let viewModel = CreateAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setViewLayout()
        setTextFieldLayout()
        setButtonLayout()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func tappedCreateButton(_ sender: HighlightButton) {
        print("tappedCreateButton")
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        viewModel.createAccountButtonDidClicked(by: email, by: password) { error in
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    
    // TODO: 입력된 email 검증하는 함수
    // TODO: 입력된 password 검증하는 함수
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text ?? "") + string
        var isValidEmail: Bool?
        var isValidPassword: Bool?
        switch textField {
        case emailTextField:
            print("shouldChangeCharactersIn emailTextField: \(text)")
            isValidEmail = viewModel.emailFormatValidationCheck(by: text)
            
            if isValidEmail ?? false {
                emailTextField.layer.borderColor = UIColor.lightGray.cgColor
                emailErrorLabel.text = ""
            } else {
                emailTextField.layer.borderColor = UIColor.red.cgColor
                emailErrorLabel.text = "유효하지 않은 이메일 형식입니다."
            }
        case passwordTextField:
            print("shouldChangeCharactersIn passwordTextField: \(text)")
            isValidPassword = viewModel.passwordFormatValidationCheck(by: text)
            if isValidPassword ?? false {
                passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
            } else {
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                passwordErrorLabel.text = "비밀번호를 6자 이상 입력하세요."
            }
        default:
            break
        }
        if (isValidEmail != nil) && (isValidPassword != nil) {
            self.createButton.isEnabled = true
        }
        return true
    }
}

private extension CreateAccountViewController {
    func setViewLayout() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setTextFieldLayout() {
        emailTextField.layer.borderWidth = 0.7
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.addLeftPadding(10)
        emailTextField.layer.cornerRadius = 8
        
        passwordTextField.layer.borderWidth = 0.7
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.addLeftPadding(10)
        passwordTextField.layer.cornerRadius = 8
    }
    
    func setButtonLayout() {
        let cornerRadius: CGFloat = 20
        
        createButton.layer.cornerRadius = cornerRadius
        createButton.isEnabled = true
    }
}
