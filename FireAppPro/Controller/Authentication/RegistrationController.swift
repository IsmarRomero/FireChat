//
//  RegistrationController.swift
//  FireAppPro
//
//  Created by Ismar Arilson Romero Deleon on 4/23/20.
//  Copyright © 2020 Ismar Arilson Romero Deleon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
class RegistrationController: UIViewController {
    // MARK: Properties
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
         return InputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"),
                                textFiel: emailTextField)
    }()
    
    private lazy var fullNameContainerView: UIView = {
         return InputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"),
                                textFiel: fullNameTextField)
    }()
    
    private lazy var userNameContainerView: UIView = {
         return InputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"),
                                textFiel: userNameTextField)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
       return InputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),
                                textFiel: passwordTextField)
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Correo")
    
    private let fullNameTextField = CustomTextField(placeholder: "Nombre completo")
    
    private let userNameTextField = CustomTextField(placeholder: "Nombre usuario")
       
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Contraseña")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Regístrate", for: .normal )
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    private let readyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let atributedTitle = NSMutableAttributedString(string: "¿Ya tienes una cuenta? ",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                    .foregroundColor: UIColor.white])
        atributedTitle.append(NSAttributedString(string: "Ingresa", attributes:
            [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(atributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    // MARK: Selectors
    
    @objc private func handleRegistration() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = userNameTextField.text?.lowercased() else { return }
        guard let profileImage = profileImage else { return }
        
        let credentials = RegistrationCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        showLoader(true, WithText: "Registrando")
        AuthService.shared.createUser(credentials: credentials) { (error) in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: FAiled to upload user data with error: \(error.localizedDescription)")
                return
            }
            
            self.dismiss(animated: true , completion: nil)
        }
        
    }
    
    @objc private func textDidChanged(sender: UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullNameTextField {
            viewModel.fullName = sender.text
        } else if sender == userNameTextField {
            viewModel.userName = sender.text
        }
        
        checkFormStatus()
    }
    @objc private func handleSelectPhoto() {
         let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
         
    }
    @objc private func handleShowLogin() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func keyboardWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc private func keyboardWillHide() {
       if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    // MARK: Helper
    
    private func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                passwordContainerView,
                                                fullNameContainerView,
                                                userNameContainerView,
                                                signUpButton])
        stack.axis = .vertical
        stack.spacing = 16.0
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                            paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(readyHaveAccountButton)
        readyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor, paddingLeft: 32.0, paddingRight: 32.0)
        configureNotificationObservers()
               
    }
    
    private func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        passwordTextField .addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        fullNameTextField .addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        
        profileImage = image
        
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal )
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 120 / 2
        
        
        dismiss(animated: true , completion: nil)
    }
}

extension RegistrationController: AuthenticationControllerProtocol {
    internal func checkFormStatus() {
        if viewModel.formIsValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
}
