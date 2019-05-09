//
//  HomeViewController.swift
//  Decide
//
//  Created by Daniel Wei on 11/9/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
import Firebase
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let usernameIdentifier = "userCell"
    let titleIdentifier = "titleCell"
    let choiceIdentifier = "choiceCell"
    let cellSpacingHeight: CGFloat = 40
    let homeDecision = HomeDecision()
    
    private let refreshControl = UIRefreshControl()
    var customView : UIView!
    
    var flagPopup = FlagPopup()
    var dimBackground: UIView!
    var popupDefaultFrame: CGRect!
    var flagHandler = FlagHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView() //hides unused cells
        tableView.estimatedRowHeight = 43.5
        tableView.estimatedSectionHeaderHeight = cellSpacingHeight;
        tableView.estimatedSectionFooterHeight = 0;
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.view.backgroundColor = UIColor(red:245/255, green: 245/255, blue: 245/255, alpha: 1)
        //add dim background
        dimBackground = UIView(frame: UIScreen.main.bounds)
        dimBackground.alpha = 0
        dimBackground.isHidden = true
        dimBackground.backgroundColor = UIColor.black
        tabBarController!.view.addSubview(dimBackground)
        //add flagging popup
        tabBarController!.view.addSubview(flagPopup)
        flagPopup.configure(text: "Report Post", handler: flagHandler)
        flagPopup.setExitButtonTarget(self, #selector(cancelReport(_:)))
        flagPopup.setMainButtonTarget(self, #selector(saveReport(_:)))
        //flag handler (the data model for reporting)
        flagHandler.configure()
        //bringing subviews to front
        tabBarController!.view.bringSubviewToFront(dimBackground)
        tabBarController!.view.bringSubviewToFront(flagPopup)
                //allows detection of keyboard appearing/disappearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        instantiateRefreshControl()
        updateData()
    }
    
    //displays the data from firebase in the homepage
    func updateData() {
        let ref = Database.database().reference().child("posts")
        
        ref.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                //clear tableview for reload
                self.homeDecision.posts.removeAll() //important
                
                for case let post as DataSnapshot in snapshot.children { //create the post and check if this user has voted on it yet.
                    //NOT using snapshot.value allows for chronological order
                    let postData = post.value as! [String : Any]
                    let currentPost = Post(title: postData["title"] as? String ?? "Title", decisions: postData["options"] as? [String] ?? ["option"], numVotes: postData["votes"] as? [Int] ?? [0,0,0], username: postData["username"] as? String ?? "USER", flagHandler: self.flagHandler, key: post.key)
                    //retrieve whether the user voted on this post or not, then show it
                    if let userVote = postData["user-votes"] as? [String : Any]{
                        guard let UID = Auth.auth().currentUser?.uid else {return}
                        if let vote = userVote[UID] as? Int {
                            currentPost.isVoteable = false
                            currentPost.userVote = vote
                        }
                    }
                    self.homeDecision.posts.insert(currentPost, at: 0)
                }
                self.tableView.reloadData()
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
                self.refreshControl.endRefreshing()
            }
            
        })
    }
    func instantiateRefreshControl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        }else{
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action:#selector(refreshData(_:)), for: .valueChanged)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            updateData()
        }
    }
    @objc private func refreshData(_ sender: Any) {
        if !tableView.isDragging {
            updateData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
              //allows detection of keyboard appearing/disappearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        //removes keyboard detection of view once it disappears, used to prevent detection when keyboard appears on NEWDECISION
        NotificationCenter.default.removeObserver(self)
    }
   
    //shift view up when keyboard appears
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !flagPopup.isHidden {
                let rect = flagPopup.frame
                if rect.intersects(keyboardSize) {
                    let offsetDist = rect.maxY - keyboardSize.minY + 10
                    flagPopup.frame = flagPopup.frame.offsetBy(dx: 0, dy: -offsetDist)
                }
            }
        }
    }
    //shift view down when keyboard disappears
    @objc func keyboardWillHide(_ notification:Notification) {
        if popupDefaultFrame != nil {
            flagPopup.frame = popupDefaultFrame
        } else {
            print("HomeViewController;keyboardWillHide(): POPUPDEFAULTFRAME DOES NOT EXIST")
        }
    }
    // MARK: - Table View delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
            return homeDecision.posts.count
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let post = homeDecision.getPost(at: section) {
            return post.decisions.count + 2 // +2 to account for username bar and title
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
    @objc func showFlagPopup(_ sender: Any) {
        self.flagPopup.isHidden = false
        self.dimBackground.isHidden = false
        UIView.transition(with: flagPopup, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.flagPopup.alpha = 1
            self.dimBackground.alpha = 0.5
        }, completion: nil )
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.flagPopup.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        popupDefaultFrame = flagPopup.frame
    }
    func closeFlagPopup() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.flagPopup.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: nil)
        
        UIView.transition(with: flagPopup, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.flagPopup.alpha = 0
            self.dimBackground.alpha = 0
        }, completion: { finished in
            self.flagPopup.isHidden = true
            self.dimBackground.isHidden = true
        })
    }
    @objc func cancelReport(_ sender: Any) {
        flagHandler.clear()
        flagPopup.clearText()
        closeFlagPopup()
    }
    @objc func saveReport(_ sender: Any) {
        //save all the data for flags
        let reason = flagHandler.getReason()
        //their reason must contain letters... so check for them
        if let range = reason.rangeOfCharacter(from: NSCharacterSet.letters) {
            print("HomeViewController;saveReport(): REPORT SENT")
            guard let post = flagHandler.getPost() else {return}
            guard let UID = Auth.auth().currentUser?.uid else {return}
            let ref = Database.database().reference().child("reported").child(post.key)
            ref.child(UID).setValue(reason)
            flagHandler.clear()
            flagPopup.clearText()
            closeFlagPopup()
        } else { //if the report doesn't contain any letters...
            print("HomeViewController;saveReport(): INVALID REPORT")
            flagHandler.clear()
            flagPopup.clearText()
            flagPopup.reason.shake()
        }
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { //username/profile pic bar
            let cell = self.tableView.dequeueReusableCell(withIdentifier: usernameIdentifier) as! UserCell
            if let post = homeDecision.getPost(at: indexPath.section) {
                cell.configure(username: post.username ?? "USER")
                cell.removeButtonTargets() //just to make sure that this wont point to the wrong cell once reused
                cell.setButtonTarget(post, #selector(Post.report(_:))) //the flag button
                cell.setButtonTarget(self, #selector(showFlagPopup(_:)))
            } else {
                cell.configure(username: "USER")
            }
            return cell
        } else if indexPath.row == 1 { //title bar
            let cell = self.tableView.dequeueReusableCell(withIdentifier: titleIdentifier) as! HomeTitleCell
            if let post = homeDecision.getPost(at: indexPath.section) {
                cell.configure(text: post.title)
            }
            return cell
        } else { //choice bars
            let cell = self.tableView.dequeueReusableCell(withIdentifier: choiceIdentifier) as! ChoiceCell
            if let post = homeDecision.getPost(at: indexPath.section) {
                if indexPath.row == post.decisions.count + 1 { //rounds corners of bottom row
                    cell.shouldRound = true
                } else {
                    cell.shouldRound = false
                }
                //configure cell with the correct percentage
                //change percentage to a decimal
                var color: UIColor!
                if let vote = post.getUserVote() { //if the post was voted on, we have to highlight what that vote was...
                    //make every nonvoted choice a different color...
                    if post.didDisplayPercents {
                        color = cell.color1
                    } else {
                        if vote + 2 == indexPath.row {
                            color = cell.color2
                        } else {
                            color = cell.color1
                        }
                    }
                } else {
                    color = cell.color1 //everything remains color1 if nothing was voted
                }
                let total = post.getTotal()
                
                cell.configure(text: post.getDecision(at: indexPath.row-2), percentage: Double(post.getVotes(at: indexPath.row - 2))/Double(total), color: color)
                if post.didDisplayPercents { //redisplay percentages if they were shown prior
                    cell.displayPercentage()
                }
            }
            return cell
        }
    }
    //animates highlighting of selection
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let post = homeDecision.getPost(at: indexPath.section)
        if post!.isVoteable && indexPath.row > 1 {
            if let cell = tableView.cellForRow(at: indexPath) as? ChoiceCell {
                UIView.animate(withDuration: 0.1, animations: {
                    cell.backgroundColor = cell.color2
                })
            }
        }
    }
    
    //animates highlighting of selection
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let post = homeDecision.getPost(at: indexPath.section)
        if post!.isVoteable && indexPath.row > 1 {
            if let cell = tableView.cellForRow(at: indexPath) as? ChoiceCell {
                UIView.animate(withDuration: 0.1, delay: 0.1, animations: {
                    cell.backgroundColor = cell.color1
                })
            }
            
        }
    }
    
    //display all rows of section if one is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        print("You tapped cell number \(indexPath.row). at post number: \(indexPath.section)")
        if indexPath.row != 0 && indexPath.row != 1 {
            if let post = homeDecision.getPost(at: indexPath.section) {
                if post.isVoteable {
                    post.vote(forDecisionAt: indexPath.row - 2)
                } //add a vote to the decision
                post.didDisplayPercents = !post.didDisplayPercents //mark the cell as displayed, regardless of whether whole post is visible, switch it each time it is pressed
                
                for index in 2..<post.decisions.count + 2 {
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: indexPath.section)) as? ChoiceCell {
                        cell.updatePercent(newPercent: post.getPercentage(forDecisionAt: index - 2)) //retrieve the updated percentage and display it
                        if post.didDisplayPercents {
                            UIView.animate(withDuration: 0.2) {
                                cell.backgroundColor = cell.color1
                            }
                            cell.displayPercentage()
                        } else {
                            if let vote = post.getUserVote() {
                                if vote + 2 == index {
                                    UIView.animate(withDuration: 0.2) {
                                        cell.backgroundColor = cell.color2
                                    }
                                }
                            }
                            cell.displayText()
                        }
                    }
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //the height of the post, to be implemented later
        return UITableView.automaticDimension
    }
   
}
