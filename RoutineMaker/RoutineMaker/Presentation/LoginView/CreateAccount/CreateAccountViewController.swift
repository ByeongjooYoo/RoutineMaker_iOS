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
