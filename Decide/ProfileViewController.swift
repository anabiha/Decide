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
    
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var yourPostsView: UIView! //the white view with user's posts
    @IBOutlet weak var yourPostsViewHeight: NSLayoutConstraint! //height of the view, will vary based on device
    var insets: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: UIScreen.main.bounds.height/2, right: 0) //content inset for tableview
    let cellSpacingHeight: CGFloat = 12
    var cellCount = 1
    let titleIdentifier = "profileTitleCell"
    let choiceIdentifier = "profileChoiceCell"
    let userPosts = HomeDecision()
    var headerLabel: UILabel!
    var tableView: UITableView!
    var analytics: ProfilePopup!
    var confirmDelete: Popup!
    var canLinkToScroll: Bool = true //unlinks the header "your posts" from scrollview when refreshing -> PREVENTS JITTERING
    var dimBackground: UIView!
    var dragToHome: UIGestureRecognizer!
    private let refreshControl = UIRefreshControl()
    let generator1 = UINotificationFeedbackGenerator()
    let generator2 = UIImpactFeedbackGenerator(style: Universal.vibrationStyle)
    override func viewDidLoad() {
        //instantiation and addition of subviews
        tableView = UITableView()
        yourPostsView.addSubview(tableView)
        headerLabel = UILabel()
        yourPostsView.addSubview(headerLabel)
        
        //tableview constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: yourPostsView.topAnchor, constant: 60).isActive = true
        tableView.leadingAnchor.constraint(equalTo: yourPostsView.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: yourPostsView.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: yourPostsView.bottomAnchor, constant: 0).isActive = true
        //setting tableview data stuff
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileTitleCell.self, forCellReuseIdentifier: titleIdentifier)
        tableView.register(ProfileChoiceCell.self, forCellReuseIdentifier: choiceIdentifier)
        tableView.tableFooterView = UIView() //hides unused cells
        tableView.backgroundColor = UIColor.clear
        // Set automatic dimensions for row height
        tableView.estimatedRowHeight = 43.5
        tableView.estimatedSectionHeaderHeight = cellSpacingHeight;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.rowHeight = UITableView.automaticDimension
        yourPostsViewHeight.constant = UIScreen.main.bounds.height
        //keeps some space between bottom of screen and the bottom of the tableview
        tableView.contentInset = insets
        tableView.separatorStyle = .none
        //header text
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: yourPostsView.topAnchor, constant: 15).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: yourPostsView.leadingAnchor, constant: 20).isActive = true
        headerLabel.text = "Your Posts"
        headerLabel.font = UIFont(name: Universal.heavyFont, size: 35)
        //gesture recognizer
        let dragView = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        yourPostsView.addGestureRecognizer(dragView)
        dragToHome = UIPanGestureRecognizer(target: self, action: #selector(wasDraggedToHome(gestureRecognizer:)))
        view.addGestureRecognizer(dragToHome)
        //instantiation and addition of subviews
        analytics = ProfilePopup()
        confirmDelete = Popup()
        dimBackground = UIView(frame: UIScreen.main.bounds)
        dimBackground.alpha = 0
        dimBackground.isHidden = true
        dimBackground.backgroundColor = UIColor.black
        tabBarController!.view.addSubview(dimBackground) //tab bar controller so that everything goes over the tab bar
        tabBarController!.view.addSubview(analytics)
        tabBarController!.view.addSubview(confirmDelete)
        //configuration of analytics popup
        analytics.configure()
        analytics.setExitButtonTarget(self, #selector(closeAnalytics(_:)))
        analytics.setDeleteButtonTarget(self, #selector(openConfirm(_:)))
        //configuration of confirmation popup
        confirmDelete.configureTwoButtons()
        confirmDelete.changeButton1(to: button.popupCancel)
        confirmDelete.changeButton2(to: button.popupDelete)
        confirmDelete.setButton1Target(self, #selector(closeConfirm(_:)))
        confirmDelete.setButton2Target(self, #selector(deletePost(_:)))
        confirmDelete.setTitle(to: "Delete Post")
        confirmDelete.setText(to: "Are you sure you want to delete this post?")
        self.yourPostsView.backgroundColor = Universal.viewBackgroundColor
        instantiateRefreshControl() //refresh animation
        updateData()
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        if dragToHome != nil {
            dragToHome.isEnabled = true
        }
    }
    func updateData() {
        guard let UID = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().root
        ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            self.userPosts.posts.removeAll()
            self.tableView.reloadData()
            var finalList: [String] = []
            let rawPostList = snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: UID).childSnapshot(forPath: "posts")
            for case let post as DataSnapshot in rawPostList.children {
                //using children and not value allows chronological orderrrr
                let key = post.key
                finalList.insert(key, at: 0)
            }
            for key in finalList {
                let postData = snapshot.childSnapshot(forPath: "posts").childSnapshot(forPath: key).value as! [String : Any]
                let currentPost = Post(title: postData["title"] as? String ?? "Title", decisions: postData["options"] as? [String] ?? ["option"], numVotes: postData["votes"] as? [Int] ?? [0,0,0], username: "N/A", flagHandler: FlagHandler(), key: key) //flaghandler is irrelevant here
                currentPost.isVoteable = false
                self.userPosts.posts.append(currentPost)
            }
            self.generator1.notificationOccurred(.success)
            //inserting new sections
            let indexSet = IndexSet(integersIn: 0..<self.userPosts.posts.count)
            self.tableView.insertSections(indexSet, with: .fade)
            self.tableView.endUpdates()
            self.refreshControl.endRefreshing()
            self.canLinkToScroll = true
        })
        
    }
    //used for switching back to home page
    @objc func wasDraggedToHome(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.view)
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            generator2.impactOccurred()
        }
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            let minDist = UIScreen.main.bounds.width/4
            if gestureRecognizer.view!.frame.minX + translation.x > 0 {
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y)
                gestureRecognizer.setTranslation(.zero, in: view)
                if gestureRecognizer.view!.frame.minX + translation.x > minDist {
                    if let tb = tabBarController as? MainTabBarController {
                        gestureRecognizer.isEnabled = false
                        tb.animateTabSwitch(to: 0, withScaleAnimation: false)
                    }
                }
            }
        } else if gestureRecognizer.state == UIGestureRecognizer.State.ended { //reset the frame if it didnt get dragged the minimum distance
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin = .zero
            }, completion: { finished in
                self.generator2.impactOccurred()
            })
            
        }
    }
    //allows shifting of the posts view
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            let translation = gestureRecognizer.translation(in: self.view)
            if gestureRecognizer.view!.frame.minY + translation.y >= UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 20 && gestureRecognizer.view!.frame.minY + translation.y < 300 {
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y)
            }
            gestureRecognizer.setTranslation(.zero, in: self.view)
        } 
    }
    func instantiateRefreshControl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        }else{
            tableView.addSubview(refreshControl)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.refreshControl.isRefreshing {
            canLinkToScroll = false
            UIView.animate(withDuration: 0.20, animations: {
                self.headerLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (finished) in
                self.updateData()
            }
        }
    }
    //data refresh when scrolling down!
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 && canLinkToScroll {
            headerLabel.setAnchorPoint(anchorPoint: .zero)
            headerLabel.transform = CGAffineTransform(scaleX: 1 + -scrollView.contentOffset.y/300, y: 1 + -scrollView.contentOffset.y/300)
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
                
                cell.configure(text: post.getDecision(at: indexPath.row-1), percentage: Double(post.getVotes(at: indexPath.row - 1))/Double(total), color: UIColor.white)
                if post.didDisplayPercents { //redisplay percentages if they were shown prior
                    cell.displayPercentage()
                }
            }
            return cell
        }
        
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.generator2.impactOccurred()
        if let post = userPosts.getPost(at: indexPath.section) {
            analytics.setPost(to: post)
        } else {
            print("ProfileViewController;didSelectRowAt(): ERROR - Post doesn't exist")
        }
        analytics.showPopup()
    }
    @objc func deletePost(_ sender: Any) {
        let ref = Database.database().reference().root
        guard let UID = Auth.auth().currentUser?.uid else {return}
        if let key = analytics.post?.key {
            ref.child("users").child(UID).child("posts").child(key).removeValue()
            ref.child("posts").child(key).removeValue()
            updateData()
            print("ProfileViewController;deletePost(): successfully deleted post with key: \(key)")
        } else {
            print("ProfileViewController;deletePost(): ERROR - popup does not have a post")
        }
        closeConfirm()
    }
    //objc wrapper for the close confirm func so that buttons can call it
    @objc func closeConfirm(_ sender: Any) {
        closeConfirm()
    }
    //close confirm popup
    func closeConfirm() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.confirmDelete.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: nil)
        
        UIView.transition(with: confirmDelete, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.confirmDelete.alpha = 0
            self.dimBackground.alpha = 0
        }, completion: { finished in
            self.confirmDelete.isHidden = true
            self.dimBackground.isHidden = true
        })
        print("ProfileViewController;closeConfirm(): confirm popup closed")
    }
    //open confirm popup
    @objc func openConfirm(_ sender: Any) {
        closeAnalytics()
        self.confirmDelete.isHidden = false
        self.dimBackground.isHidden = false
        UIView.transition(with: confirmDelete, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.confirmDelete.alpha = 1
            self.dimBackground.alpha = 0.5
        }, completion: nil )
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.confirmDelete.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        print("ProfileViewController;openConfirm(): confirm popup opened")
    }
    func closeAnalytics() {
        analytics.hidePopup()
    }
    //the objc wrapper for close more info, used by exit button on popup
    @objc func closeAnalytics(_ sender: Any) {
        closeAnalytics()
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
    
    @IBAction func didUnwindFromEditProfile(sender: UIStoryboardSegue){
        guard let usernameEdit = sender.source as? EditProfileViewController else{return}
        Username.text = usernameEdit.Username.text
    }
    
}

