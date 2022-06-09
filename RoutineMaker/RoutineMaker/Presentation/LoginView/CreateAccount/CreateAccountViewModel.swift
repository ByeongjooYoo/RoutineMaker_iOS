//
//  CreateAccountViewModel.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/06/06.
//

import Foundation

class CreateAccountViewModel {
    func emailFormatValidationCheck(by email: String) -> Bool {
        return false
    }
    
    func passwordFormatValidationCheck(by password: String) -> Bool {
        return password.count >= 6
    }
    
    func createAccountButtonDidClicked(email: String, paswword: String) {
        
    }
}
