//
//  CreateAccountViewModel.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/06/06.
//

import Foundation

class CreateAccountViewModel {
    let createAccountUseCase = CreateAccountUseCaseImpl()
    
    func emailFormatValidationCheck(by email: String) -> Bool {
        return createAccountUseCase.checkEmailFormat(by: email)
    }
    
    func passwordFormatValidationCheck(by password: String) -> Bool {
        return password.count >= 6
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
