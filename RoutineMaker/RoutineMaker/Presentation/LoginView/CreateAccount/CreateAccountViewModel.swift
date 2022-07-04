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
    func createAccountButtonDidClicked(by email: String, by paswword: String) {
        createAccountUseCase.createEmailAccount(by: email, by: paswword) {
            //TODO: 로그인 페이지로 이동
        }
    }
}
