//
//  CreateAccountRepository.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/07/04.
//

import Foundation
import FirebaseAuth

protocol CreateAccountRepository {
    func createEmailAccount(by email: String, by password: String, completion: @escaping (Error?) -> Void)
}

class CreateAccountRepositoryImpl: CreateAccountRepository {
    func createEmailAccount(by email: String, by password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
