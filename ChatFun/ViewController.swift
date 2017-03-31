//
//  ViewController.swift
//  FireBase
//
//  Created by MGX82 on 3/28/17.
//  Copyright © 2017 ThangLQ. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            performSelector(onMainThread: #selector(handleLogout), with: nil, waitUntilDone: false)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
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

