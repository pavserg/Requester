//
//  Validator.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 23.10.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//


import Foundation
import UIKit

protocol ValidatorConvertible {
    func validated(_ value: String) -> Bool
    func validated(textField: UITextField, value: String, string: String, range: NSRange) -> Bool
}

extension ValidatorConvertible {
    
    func validated(_ value: String) -> Bool {
        return false
    }
    
    func validated(textField: UITextField, value: String, string: String, range: NSRange) -> Bool {
        return false
    }
}

enum ValidatorType {
    case email
    case password
    case age
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .password: return PasswordValidator()
        case .age: return AgeValidator()
        }
    }
}

class AgeValidator: ValidatorConvertible {
    func validated(_ value: String) -> Bool {
        guard !value.isEmpty else { return false }
        guard let age = Int(value) else { return false }
        guard value.count < 3 else { return false }
        guard age >= 18 else { return false }
        return true
    }
}


struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String) -> Bool {
        guard !value.isEmpty else { return false }
        guard value.count >= 6 else { return false }
        return true
    }
}

struct GeneralTextInput: ValidatorConvertible {
    func validated(_ value: String) -> Bool {
        return !value.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

struct EmailValidator: ValidatorConvertible {
    
    func validated(_ value: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = value as NSString
            let results = regex.matches(in: value, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
}

extension String {
   var containsSpecialCharacter: Bool {
      let regex = ".*[^A-Za-z0-9].*"
      let testString = NSPredicate(format:"SELF MATCHES %@", regex)
      return testString.evaluate(with: self)
   }
}
