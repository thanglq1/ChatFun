//
//  ChatLogController.swift
//  ChatFun
//
//  Created by MGX82 on 4/10/17.
//  Copyright © 2017 ThangLQ. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate{

    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    lazy var inputTextFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.placeholder = "Enter message..."
        textFiled.backgroundColor = UIColor.white
        textFiled.delegate = self
        
        return textFiled
    }()
    
    var titleBar: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        
        setupInputView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func setupInputView() {
        let inputViewContainer = UIView()
        inputViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(inputViewContainer)
        
        inputViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputViewContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        inputViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        inputViewContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let sendButton = UIButton(type: .system)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        inputViewContainer.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: inputViewContainer.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: inputViewContainer.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        sendButton.heightAnchor.constraint(equalTo: inputViewContainer.heightAnchor).isActive = true

        inputViewContainer.addSubview(inputTextFiled)
        
        inputTextFiled.leftAnchor.constraint(equalTo: inputViewContainer.leftAnchor, constant: 8).isActive = true
        inputTextFiled.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextFiled.centerYAnchor.constraint(equalTo: inputViewContainer.centerYAnchor).isActive = true
        inputTextFiled.heightAnchor.constraint(equalTo: inputViewContainer.heightAnchor).isActive = true
        
        let seprator = UIView()
        seprator.translatesAutoresizingMaskIntoConstraints = false
        seprator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        inputViewContainer.addSubview(seprator)
        
        seprator.leftAnchor.constraint(equalTo: inputViewContainer.leftAnchor).isActive = true
        seprator.rightAnchor.constraint(equalTo: inputViewContainer.rightAnchor).isActive = true
        seprator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seprator.topAnchor.constraint(equalTo: inputViewContainer.topAnchor).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func handleSend() {
        
        let ref = FIRDatabase.database().reference().child("message")
        let childRef = ref.childByAutoId()
        let toId = user?.userId
        let fromId = FIRAuth.auth()?.currentUser?.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        childRef.setValue(["text": inputTextFiled.text!, "fromId": fromId!, "toId": toId!, "timestamp":timestamp])
    }
}
