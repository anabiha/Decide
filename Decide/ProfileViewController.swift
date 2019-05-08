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
    @IBOutlet weak var headerLabel: UILabel!
    var insets: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0) //content inset for tableview
    let cellSpacingHeight: CGFloat = 14
    var cellCount = 1
    var refreshTriggered = false
    let userPosts = HomeDecision()
    let titleIdentifier = "profileTitleCell"
    let choiceIdentifier = "profileChoiceCell"
    let headerIdentifier = "headerCell"
    var moreInfo: ProfilePopup!
    var dimBackground: UIView!
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
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: headerIdentifier)
        updateData()
        //instantiation and addition of subviews
        moreInfo = ProfilePopup()
        dimBackground = UIView(frame: UIScreen.main.bounds)
        dimBackground.alpha = 0
        dimBackground.isHidden = true
        dimBackground.backgroundColor = UIColor.black
        tabBarController!.view.addSubview(dimBackground)
        tabBarController!.view.addSubview(moreInfo)
        moreInfo.configure()
        moreInfo.setExitButtonTarget(self, #selector(closeMoreInfo(_:)))
        self.view.backgroundColor = UIColor(red:245/255, green: 245/255, blue: 245/255, alpha: 1)
        super.viewDidLoad()
    }
    func updateData() {
        
        guard let UID = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().root
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            self.userPosts.posts.removeAll()
            var finalList: [String] = []
            let rawPostList = snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: UID).childSnapshot(forPath: "posts")
                for case let post as DataSnapshot in rawPostList.children { //using children and not value allows chronological order
                    let key = post.key
                    finalList.insert(key, at: 0)
                }
                
                for key in finalList {
                    let postData = snapshot.childSnapshot(forPath: "posts").childSnapshot(forPath: key).value as! [String : Any]
                    let currentPost = Post(title: postData["title"] as? String ?? "Title", decisions: postData["options"] as? [String] ?? ["option"], numVotes: postData["votes"] as? [Int] ?? [0,0,0], flagHandler: FlagHandler(), key: key) //flaghandler is irrelevant here
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
            
        })
        
        refreshTriggered = false
    }
    //data refresh when scrolling down!
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //increase size of button and scroll down when scrolling tableview down
        if scrollView.contentOffset.y < 0 {
            headerLabel.setAnchorPoint(anchorPoint: CGPoint(x: 0, y: 0))
            headerLabel.transform = CGAffineTransform(scaleX: 1 + abs(scrollView.contentOffset.y)/250, y: 1 + abs(scrollView.contentOffset.y)/250)
        }
        if !refreshTriggered && scrollView.contentOffset.y < -100 {
            refreshTriggered = true
            updateData()
        }
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
        return userPosts.posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let post = userPosts.getPost(at: section) {
            return post.decisions.count + 1 // +1 to account for title
        } else {
            return 0
        }
        
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
        if indexPath.row == 0 { //title bar
            let cell = self.tableView.dequeueReusableCell(withIdentifier: titleIdentifier) as! ProfileTitleCell
            if let post = userPosts.getPost(at: indexPath.section) {
                cell.configure(text: post.title)
            }
            return cell
        } else { //choice bars
            let cell = self.tableView.dequeueReusableCell(withIdentifier: choiceIdentifier) as! ProfileChoiceCell
            if let post = userPosts.getPost(at: indexPath.section) {
                if indexPath.row == post.decisions.count { //rounds corners of bottom row
                    cell.shouldRound = true
                } else {
                    cell.shouldRound = false
                }
                //configure cell with the correct percentage
                //change percentage to a decimal
                let total = post.getTotal()
                
                cell.configure(text: post.getDecision(at: indexPath.row-1), percentage: Double(post.getVotes(at: indexPath.row - 1))/Double(total), color: cell.color1)
                if post.didDisplayPercents { //redisplay percentages if they were shown prior
                    cell.displayPercentage()
                }
            }
            return cell
        }
        
    }
    
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
//        print("You tapped cell number \(indexPath.row). at post number: \(indexPath.section)")
//        if let post = userPosts.getPost(at: indexPath.section) {
//            post.didDisplayPercents = !post.didDisplayPercents //mark the cell as displayed, regardless of whether whole post is visible, switch it each time it is pressed
//            for index in 1..<post.decisions.count + 1 {
//                if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: indexPath.section)) as? ProfileChoiceCell {
//                    if post.didDisplayPercents {
//                        UIView.animate(withDuration: 0.2) {
//                            cell.backgroundColor = cell.color1
//                        }
//                        cell.displayPercentage()
//                    } else {
//                        cell.displayText()
//                    }
//                }
//            }
//        }
        let frame = tableView.convert(tableView.rect(forSection: indexPath.section), to: self.view)
        if let post = userPosts.getPost(at: indexPath.section) {
             moreInfo.setPost(to: post)
        }
        showMoreInfo(withFrame: frame)
    }
    
    @objc func closeMoreInfo(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionCrossDissolve, .curveEaseIn], animations: {
            self.moreInfo.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: nil)
        UIView.transition(with: moreInfo, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.moreInfo.alpha = 0
            self.dimBackground.alpha = 0
        }, completion: { finished in
            self.moreInfo.isHidden = true
            self.dimBackground.isHidden = true
        })
    }
    func showMoreInfo(withFrame frame: CGRect) {
        moreInfo.setSize(toFrame: frame)
        self.moreInfo.isHidden = false
        self.dimBackground.isHidden = false
        UIView.transition(with: moreInfo, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.moreInfo.alpha = 1
            self.dimBackground.alpha = 0.3
        }, completion: nil )
        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: {
            self.moreInfo.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
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

