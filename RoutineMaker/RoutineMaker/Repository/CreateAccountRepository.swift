//
//  CreateAccountRepository.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/07/04.
//

import Foundation

protocol CreateAccountRepository {
    func createEmailAccount(by email: String, by password: String)
}

class CreateAccountRepositoryImpl: CreateAccountRepository {
    func createEmailAccount(by email: String, by password: String) {
        
    }
}
