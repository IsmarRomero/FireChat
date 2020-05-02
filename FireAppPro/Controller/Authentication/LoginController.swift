//
//  LoginController.swift
//  FireAppPro
//
//  Created by Ismar Arilson Romero Deleon on 4/23/20.
//  Copyright © 2020 Ismar Arilson Romero Deleon. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

protocol AuthenticationControllerProtocol {
    func checkFormStatus()
}

class LoginController: UIViewController {
    // MARK: Properties
    
    private var viewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
        let iconV = UIImageView()
        iconV.image = UIImage(systemName: "bubble.right")
        iconV.tintColor = .white
        return iconV
    }()
    
    private lazy var emailContainerView: UIView = {
         return InputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"),
                                textFiel: emailTextField)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
       return InputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),
                                textFiel: passwordTextField)
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ingresar", for: .normal )
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Correo")
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Contraseña")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let atributedTitle = NSMutableAttributedString(string: "¿No tienes un usuario? ",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                    .foregroundColor: UIColor.white])
        atributedTitle.append(NSAttributedString(string: "Registrate", attributes:
            [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(atributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShadowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Selectors
    @objc private func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        showLoader(true, WithText: "Ingresando")
        
        AuthService.shared.logUserIn(withEmail: email, password: password) {
            result, error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: FAiled to login with error: \(error.localizedDescription)")
                return
            }
            print("DEBUG: User login success ")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleShadowSignUp() {
        let controller = RegistrationController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func textDidChanged(sender: UITextField) {
        switch sender {
        case emailTextField:
            viewModel.email = sender.text ?? ""
        case passwordTextField:
            viewModel.password = sender.text ?? ""
        default:
            break
        }
        
        checkFormStatus()
    }
    
    // MARK: Helper
    
    private func configureUI() { 
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .systemPurple
        configureGradientLayer()
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.spacing = 16.0
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor, paddingLeft: 32.0, paddingRight: 32.0)
        
        emailTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        
        passwordTextField .addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
    }
}

extension LoginController: AuthenticationControllerProtocol {
    internal func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
}
