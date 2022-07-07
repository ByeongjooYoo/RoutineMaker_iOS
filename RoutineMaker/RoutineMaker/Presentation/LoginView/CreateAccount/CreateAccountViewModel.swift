//
//  CreateAccountViewModel.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/06/06.
//

import Foundation

protocol CreateAccountViewModelDelegate: AnyObject {
    func isCreateButtonEnabledDidChange()
    func emailDidChange(with isVaild: Bool)
    func passwordDidChange(with isVaild: Bool)
}

class CreateAccountViewModel {
    let createAccountUseCase = CreateAccountUseCaseImpl()
    
    weak var delegate: CreateAccountViewModelDelegate?
    
    var email: String? {
        didSet {
            updateIsCreateButtonEnabled()
            delegate?.emailDidChange(with: emailFormatValidationCheck())
        }
    }
    
    var password: String? {
        didSet {
            updateIsCreateButtonEnabled()
            delegate?.passwordDidChange(with: passwordFormatValidationCheck())
        }
    }
    
    var isCreateButtonEnabled: Bool = false {
        didSet {
            delegate?.isCreateButtonEnabledDidChange()
        }
    }
    
    func emailFormatValidationCheck() -> Bool {
        createAccountUseCase.checkEmailFormat(by: email)
    }
    
    func passwordFormatValidationCheck() -> Bool {
        createAccountUseCase.checkPasswordFormat(by: password)
    }
    
    func emailDidChange(to email: String?) {
        self.email = email
    }
    
    func passwordDidChange(to password: String?) {
        self.password = password
    }
    
    func updateIsCreateButtonEnabled() {
        isCreateButtonEnabled = emailFormatValidationCheck() && passwordFormatValidationCheck()
    }
    
    
    //TODO: 회원가입 로직 구현
    func createAccountButtonDidClicked(by email: String, by paswword: String, completion: @escaping (String?) -> Void) {
        createAccountUseCase.createEmailAccount(by: email, by: paswword) { errorMessage in
            if let errorMessage = errorMessage {
                completion(errorMessage)
            } else {
                completion(nil)
            }
        }
    }
}
