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

class PostCell: UITableViewCell {
    
     @IBOutlet weak var questionLabel: UILabel!
    
    
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var insets: UIEdgeInsets = UIEdgeInsets.init(top: 45, left: 0, bottom: 0, right: 0) //content inset for tableview
    // this object will be used to retrieve data from firebase
    let data = RetrieveData()
    var cellCount = 4 //current number of cells, start at 4
    let cellSpacingHeight: CGFloat = 14
    
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
        
       super.viewDidLoad()
        
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
        return cellCount
    }
    // There is just one row in every section
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
        if indexPath.section == cellCount - 1 {
            return 30 //the add button is this height
        } else {
            return UITableView.automaticDimension
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        
     //   let ref = Database.database().reference().root
     //   let userKey = Auth.auth().currentUser?.uid
        
     //   ref.child("posts").child(userKey!).observeSingleEvent(of: .value, with: { snapshot in
            
      //      if !snapshot.exists() { return }
            
       //     cell.questionLabel.text = snapshot.childSnapshot(forPath: "title").value as? String
            
       // })
        
        return cell
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
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

