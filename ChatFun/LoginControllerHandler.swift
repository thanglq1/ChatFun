//
//  LoginControllerHandler.swift
//  ChatFun
//
//  Created by MGX82 on 4/3/17.
//  Copyright © 2017 ThangLQ. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func handleProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("user cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImagePicker: UIImage?
       
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImagePicker = editedImage
        } else if let originImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImagePicker = originImage
        }
        
        if let selectImage = selectedImagePicker {
            self.profileImage.image = selectImage
        }
        
        dismiss(animated: true, completion: nil)
        
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
            
            let storagePref = FIRStorage.storage().reference().child("\(uid)-avatar.jpg")
            if let uploadData = UIImageJPEGRepresentation(self.profileImage.image!, 0.1) {
//            if let uploadData = UIImagePNGRepresentation(self.profileImage.image!) {
                storagePref.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print("error = \(error)")
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        let fbDatareference = FIRDatabase.database().reference()
                        print("insert db start")
                        fbDatareference.child("users").child(uid).setValue(["name":name, "email":email, "profileImageURL": profileImageURL])
                        print("insert db end")
                        self.updateTitle?.updateTitleBar()
                    }
                })
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
}
