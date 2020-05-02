//
//  RegistrationViewModel.swift
//  FireAppPro
//
//  Created by Ismar Arilson Romero Deleon on 4/28/20.
//  Copyright © 2020 Ismar Arilson Romero Deleon. All rights reserved.
//

import Foundation

struct RegistrationViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    var fullName: String?
    var userName: String?
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false &&
        fullName?.isEmpty == false && userName?.isEmpty == false
    }
}
