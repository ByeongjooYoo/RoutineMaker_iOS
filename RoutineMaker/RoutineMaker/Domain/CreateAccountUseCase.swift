//
//  CreateAccountUseCase.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/06/07.
//

import Foundation

protocol CreateAccountUseCase {
    func checkEmailFormat(by email: String) -> Bool
    func createEmailAccount(by email: String, by password: String, completion: () -> Void)
}

class CreateAccountUseCaseImpl: CreateAccountUseCase {
    func checkEmailFormat(by email: String) -> Bool {
        let pattern: String = "^[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
        
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    
    func createEmailAccount(by email: String, by password: String, completion: () -> Void) {
        
    }
}
