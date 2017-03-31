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
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
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
        loginRegisterBtn.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return loginRegisterBtn
    }()
    
    func handleLoginRegister() {
        loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? handleLogin(): handleRegister()
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("email or password not vaild")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error) in
        
            if error != nil {
                print("login error hazz \(String(describing: error))")
                return
            }
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    func handleRegister() {
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            print("name or email or password not vaild")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, error) in
            print("name= \(name) email = \(email) password = \(password)")
            
            if error != nil {
                print("error hazzz = String(error)")
                return
            }
            
            guard let uid = user?.uid else {
                print("uid nil hazzz")
                return
            }
            print("USERID \(uid)")
            let fbDatareference = FIRDatabase.database().reference()
            fbDatareference.child("users").child(uid).setValue(["name":name, "email":email])
            self.dismiss(animated: true, completion: nil)
        })
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
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        var segmentedControl = UISegmentedControl(items: ["Login", "Register"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(loginRegisterChangeUI), for: .valueChanged)
        return segmentedControl
    }()
    
    func loginRegisterChangeUI() {
        let selectedSegmentIndex = loginRegisterSegmentedControl.selectedSegmentIndex
        
        // set title of login register button
        
        let title = loginRegisterSegmentedControl.titleForSegment(at: selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)

        // set height of inputContainerView
        
        let heightOfInputViewContainer: CGFloat = selectedSegmentIndex == 0 ? 100 : 150
        inputContainerViewHeightAnchor?.constant = heightOfInputViewContainer
        
        // set height of name text field
        
        let multiplierOfNameTextField: CGFloat = selectedSegmentIndex == 0 ? 0 : 1/3
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: multiplierOfNameTextField)
        nameTextFieldHeightAnchor?.isActive = true
        
        // set height of email text field
        
        let multiplierOfEmailTextField: CGFloat = selectedSegmentIndex == 0 ? 1/2 : 1/3
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: multiplierOfEmailTextField)
        emailTextFieldHeightAnchor?.isActive = true
        
        // set height of password text field
        
        let multiplierOfPassTextField: CGFloat = selectedSegmentIndex == 0 ? 1/2 : 1/3
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: multiplierOfPassTextField)
        passwordTextFieldHeightAnchor?.isActive = true

        print("inputcontainer = \(String(describing: inputContainerViewHeightAnchor))")
        print("nameTf = \(String(describing: nameTextFieldHeightAnchor))")
        print("emailTf = \(String(describing: emailTextFieldHeightAnchor))")
        print("passTf = \(String(describing: passwordTextFieldHeightAnchor))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImage)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        
    }
    
    func setupInputsContainerView() {
        // constraint x, y, width, height
        
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSparatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSepratorView)
        inputContainerView.addSubview(passwordTextField)
        
        // constraint x, y, width, height
        
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // constraint x, y, width, height
        
        nameSparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSparatorView.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor).isActive = true
        nameSparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // constraint x, y, width, height
        
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSparatorView.bottomAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true

        
        // constraint x, y, width, height
        
        emailSepratorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSepratorView.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor).isActive = true
        emailSepratorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSepratorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // constraint x, y, width, height
        
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSepratorView.bottomAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
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
        profileImage.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginRegisterSegmentedControl() {
        // constrainst x, y, width, height
        
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
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
