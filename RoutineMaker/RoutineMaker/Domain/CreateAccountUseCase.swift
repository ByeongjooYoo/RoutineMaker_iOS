//
//  CreateAccountUseCase.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/06/07.
//

import Foundation

protocol CreateAccountUseCase {
    func checkEmailFormat(by email: String?) -> Bool
    func checkPasswordFormat(by password: String?) -> Bool
    func createEmailAccount(by email: String, by password: String, completion: @escaping (String?) -> Void)
}

class CreateAccountUseCaseImpl: CreateAccountUseCase {
    var createAccountRepository = CreateAccountRepositoryImpl()
    
    func checkEmailFormat(by email: String?) -> Bool {
        guard let email = email else { return false }
        let pattern: String = "^[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
        
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    
    func checkPasswordFormat(by password: String?) -> Bool {
        guard let password = password else { return false }
        return password.count >= 6
    }
    
    func createEmailAccount(by email: String, by password: String, completion: @escaping (String?) -> Void) {
        createAccountRepository.createEmailAccount(by: email, by: password) { error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
}
