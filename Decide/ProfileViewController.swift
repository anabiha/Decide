//
//  ProfileViewController.swift
//  Decide
//
//  Created by Daniel Wei on 11/4/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseDatabase
import FirebaseAuth


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var insets: UIEdgeInsets = UIEdgeInsets.init(top: 45, left: 0, bottom: 0, right: 0) //content inset for tableview
    let cellSpacingHeight: CGFloat = 14
    var cellCount = 1
    let userPosts = HomeDecision()
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() //hides unused cells
        tableView.backgroundColor = UIColor.clear
        // Set automatic dimensions for row height
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        //keeps some space between bottom of screen and the bottom of the tableview
        tableView.contentInset = insets
        updateData()
        
       super.viewDidLoad()
        
    }
    func updateData() {
        
        guard let UID = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().root
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            var finalList: [String] = []
            if let rawPostList = snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: UID).childSnapshot(forPath: "posts").value as? [String : Any] {
              for post in rawPostList {
                let key = post.key
                finalList.insert(key, at: 0)
                }
            
           
            for key in finalList {
                let postData = snapshot.childSnapshot(forPath: "posts").childSnapshot(forPath: key).value as! [String : Any]
                let currentPost = HomeDecision.Post(title: postData["title"] as? String ?? "Title", decisions: postData["options"] as? [String] ?? ["option"], numVotes: postData["votes"] as? [Int] ?? [0,0,0], key: key, username:postData["username"] as! String)
                currentPost.isVoteable = false
                self.userPosts.posts.append(currentPost)
            }

                DispatchQueue.main.async {

                    self.tableView.beginUpdates()
                    let indexPath = IndexPath(row: 1, section: self.cellCount-1)
                    let index = IndexSet([indexPath.section])

                    if(self.cellCount-1 > indexPath.section) {

                        self.tableView.insertSections(index, with: .automatic)
                        
                    }

                    self.tableView.endUpdates()

                }

                self.tableView.reloadData()
            }

        })
    }
    
    //scrolls the tableview upward when the keyboard shows
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: insets.top, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        tableView.contentInset = insets
    }
    
    //returns the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.cellCount
        
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    //the height of the post
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! ViewControllerTableViewCell
      
        return cell
        
    }
    
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("post cell tapped")
       
    }
    
    
    
    
    @IBAction func logOutButton(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            
            do {
                
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Login", bundle:nil).instantiateInitialViewController()
                present(storyboard!, animated: true, completion: nil)
                
            } catch let error as NSError {
                
                print(error.localizedDescription)
                
            }
            
        }
    
    }
    
    
    
}

