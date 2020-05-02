//
//  LoginViewModel.swift
//  FireAppPro
//
//  Created by Ismar Arilson Romero Deleon on 4/24/20.
//  Copyright © 2020 Ismar Arilson Romero Deleon. All rights reserved.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel  {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
