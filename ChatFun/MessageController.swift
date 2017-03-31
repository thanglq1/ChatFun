//
//  ViewController.swift
//  FireBase
//
//  Created by MGX82 on 3/28/17.
//  Copyright © 2017 ThangLQ. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkUserLogined()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Message", style: .plain, target: self, action: #selector(handleNewMessage))
    }
    
    func handleNewMessage() {
        let newMessageControler = NewMessageController()
        present(newMessageControler, animated: true, completion: nil)
    }
    
    func checkUserLogined() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
             print("uid nil")
            performSelector(onMainThread: #selector(handleLogout), with: nil, waitUntilDone: false)
        }else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            print("uid = \(String(describing: uid))")
            let ref = FIRDatabase.database().reference()
            ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let value = snapshot.value as? [String: AnyObject] {
                    let name = value["name"]
                    self.navigationItem.title = name as? String
                }
            })
        }
    }
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print("handle logout error \(error)")
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil) // present() <=> presentViewController()
        
    }
}

