//
//  LoginController.swift
//  FireBase
//
//  Created by MGX82 on 3/28/17.
//  Copyright © 2017 ThangLQ. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    var inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        var loginRegisterBtn = UIButton()
        loginRegisterBtn.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        loginRegisterBtn.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterBtn.setTitle("Register", for: .normal)
        loginRegisterBtn.layer.cornerRadius = 5
        loginRegisterBtn.layer.masksToBounds = true
        loginRegisterBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginRegisterBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        return loginRegisterBtn
    }()
    
    func register() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, error) in })
    }
    
    var nameTextField: UITextField = {
        let nameTF = UITextField()
        nameTF.placeholder = "Name"
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        return nameTF
    }()

    var nameSparatorView: UIView = {
        let nameLine = UIView()
        nameLine.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        nameLine.translatesAutoresizingMaskIntoConstraints = false
        return nameLine
    }()
    
    
    var emailTextField: UITextField = {
        let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.placeholder = "Email"
        return email
    }()
    
    var emailSepratorView: UIView = {
        let emailSeprator = UIView()
        emailSeprator.translatesAutoresizingMaskIntoConstraints = false
        emailSeprator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        return emailSeprator
    }()
    
    var passwordTextField: UITextField = {
       let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.isSecureTextEntry = true
        password.placeholder = "Password"
        return password
    }()
    
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ic_no_avatar")
        imageView.contentMode = .scaleAspectFill
        // change image to white color
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImage)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        
    }
    
    func setupInputsContainerView() {
        // constraint x, y, width, height
        
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSparatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSepratorView)
        inputContainerView.addSubview(passwordTextField)
        
        // constraint x, y, width, height
        
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        // constraint x, y, width, height
        
        nameSparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // constraint x, y, width, height
        
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        
        // constraint x, y, width, height
        
        emailSepratorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSepratorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSepratorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSepratorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // constraint x, y, width, height
        
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSepratorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor).isActive = true
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProfileImageView() {
        // constrainst x, y, width, height
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    // change status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
