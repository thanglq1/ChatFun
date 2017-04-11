//
//  ViewController.swift
//  FireBase
//
//  Created by MGX82 on 3/28/17.
//  Copyright © 2017 ThangLQ. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController, UpdateTitleBarDelegate {
    
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkUserLogined()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Message", style: .plain, target: self, action: #selector(handleNewMessage))
        print("gogogo->")
        observeMessage()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.fromId
        cell.detailTextLabel?.text = message.text
        
        return cell
    }
    
    func observeMessage() {
        let ref = FIRDatabase.database().reference().child("message")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            }, withCancel: nil)
    }
    
    func handleNewMessage() {
        let newMessageControler = NewMessageController()
        newMessageControler.messController = self
        let navigation = UINavigationController(rootViewController: newMessageControler)
        present(navigation, animated: true, completion: nil)
    }
    
    func checkUserLogined() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
             print("uid nil")
            performSelector(onMainThread: #selector(handleLogout), with: nil, waitUntilDone: false)
        }else {
            fetchUserNameUpdateTitleBar()
        }
    }
    
    func fetchUserNameUpdateTitleBar() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        print("uid = \(String(describing: uid))")
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            print("snapshot->\(snapshot)")
            if let value = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(value)
                self.setUpTitleBarUser(user: user)
                
                self.setUpTitleBarUser(user: user)
//                let name = value["name"]
//                print("name->\(name)")
//                self.navigationItem.title = name as? String
            }
        })
    }
    
    func setUpTitleBarUser(user: User) {
        let titleView = UIView();
        titleView.frame = CGRect(x: 0, y: 0, width: 150, height: 40)

        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(containerView)
        
        let imageProfile = UIImageView()
        imageProfile.translatesAutoresizingMaskIntoConstraints = false
        imageProfile.layer.cornerRadius = 20
        imageProfile.clipsToBounds = true
        imageProfile.contentMode = .scaleAspectFill
        
        imageProfile.loadImageURLUsingCache(stringURL: user.profileImageURL!)
        containerView.addSubview(imageProfile)
        
        imageProfile.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        imageProfile.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        imageProfile.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageProfile.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        let titleBar = UILabel()
        containerView.addSubview(titleBar)
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        
        titleBar.text = user.name
        titleBar.leftAnchor.constraint(equalTo: imageProfile.rightAnchor, constant: 8).isActive = true
        titleBar.centerYAnchor.constraint(equalTo: imageProfile.centerYAnchor).isActive = true
        titleBar.heightAnchor.constraint(equalTo: imageProfile.heightAnchor).isActive = true
        titleBar.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true

//        let gesture = UITapGestureRecognizer(target: self, action: #selector(showChatLog))
//        titleView.addGestureRecognizer(gesture)
        
        self.navigationItem.titleView = titleView
    }
    
    func showChatLogForUser(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func updateTitleBar() {
        fetchUserNameUpdateTitleBar()
    }
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print("handle logout error \(error)")
        }
        
        let loginController = LoginController()
        loginController.updateTitle = self
        present(loginController, animated: true, completion: nil) // present() <=> presentViewController()
    }
}

