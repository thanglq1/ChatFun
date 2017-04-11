//
//  NewMessageController.swift
//  ChatFun
//
//  Created by ThangLQ on 3/31/17.
//  Copyright © 2017 ThangLQ. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellId = "cellId"
    var users = [User]()
    var messController: MessageController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

       
//        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        getListUsers()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func getListUsers() {
        let ref = FIRDatabase.database().reference()
        ref.child("users").observe(.childAdded, with: {(snapshot) in
            if let response = snapshot.value as? [String:AnyObject] {
                print(response)
                let user = User()
                user.setValuesForKeys(response)
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let myCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        myCell.textLabel?.text = user.name
        myCell.detailTextLabel?.text = user.email
        myCell.imageView?.contentMode = .scaleAspectFill
        if let profileImageURL = user.profileImageURL {
                myCell.imageViewProfile.loadImageURLUsingCache(stringURL: profileImageURL)
        }
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        let user = users[indexPath.row]
        messController?.showChatLogForUser(user: user)
    }
}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 56, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 56, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    var imageViewProfile: UIImageView = {
        let image = UIImage(named: "ic_no_avatar")
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        return iv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init must be implement")
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(imageViewProfile)
        
        imageViewProfile.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        imageViewProfile.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageViewProfile.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageViewProfile.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
}
