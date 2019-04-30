//
//  NewDecisionViewController.swift
//  Decide
//
//  Created by Daniel Wei on 11/4/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
import Firebase


class NewDecisionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postButton: CustomButton!
    @IBOutlet weak var cancelButton: UIButton!
    //
    @IBOutlet weak var cancelButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonWidth: NSLayoutConstraint!
    
    var cancelTriggered: Bool = false
    var decision = Decision() //data manager
    var insets: UIEdgeInsets = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0) //content inset for tableview
    var cellCount = 4 //current number of cells, start at 4
    let maxCellCount = 8 //max number of cells, should be an even number
    let cellReuseIdentifier = "decisionItemCell" //reuse identifiers
    let addButtonCellReuseIdentifier = "addButtonCell"
    let questionBarCellReuseIdentifier = "questionBarCell"
    let cellSpacingHeight: CGFloat = 10
    let screenSize = UIScreen.main.bounds
    var defaultCancelFrame: CGRect?
    var popup: Popup!
    var tagPopup: TagPopup!
    var dimBackground: UIView!
    //Background is an IMAGEVIEW
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        //DO NOT REGISTER THE CELL CLASSES HERE, ALREADY DONE IN INTERFACEBUILDER!!!!!!!
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() //hides unused cells
        tableView.backgroundColor = UIColor.clear
        // Set automatic dimensions for row height
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        //keeps some space between bottom of screen and the bottom of the tableview
        tableView.contentInset = insets
        self.view.backgroundColor = UIColor(red:250/255, green: 250/255, blue: 250/255, alpha: 1)
        //configure post button, popup buttons
        postButton.configure(tuple: button.post)
        //configure decision object with cells
        decision.configure(withSize: cellCount - 1)
        
        //add keyboard observer, allows for actions when keyboard appears/disappears
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //tell view what the frame of the cancelbutton looks like
        defaultCancelFrame = cancelButton.frame
        
        dimBackground = UIView(frame: UIScreen.main.bounds)
        dimBackground.alpha = 0
        dimBackground.isHidden = true
        dimBackground.backgroundColor = UIColor.black
        view.addSubview(dimBackground)
        //popup
        popup = Popup()
        self.view.addSubview(popup)
        popup.configureTwoButtons()
        
        tagPopup = TagPopup()
        self.view.addSubview(tagPopup)
        tagPopup.configure(handler: decision)
        tagPopup.setButtonTarget(self, #selector(saveDecision(_:)))
        //view controller is behind dim background which is behind the popup
        self.view.bringSubviewToFront(dimBackground)
        self.view.bringSubviewToFront(popup)
        self.view.bringSubviewToFront(tagPopup)
        //keep cancelButton hidden while sliding up
        cancelButton.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        cancelButton.alpha = 1
    }
    override func viewWillDisappear(_ animated: Bool) {
        cancelButton.alpha = 0
    }
    /*
     Works in conjunction with decisionitem func "shift" which shifts the cell based on the keyboard size
     whenever a cell is selected
     */
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            decision.keyboardSize = keyboardSize
        }
    }
    //shift tableview down when keyboard disappears
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
    
    //cool animations when scrolling!
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //increase size of button and scroll down when scrolling tableview down
        if scrollView.contentOffset.y < -insets.top {
            if defaultCancelFrame != nil {
                cancelButton.frame = defaultCancelFrame!.offsetBy(dx: 0, dy: -(scrollView.contentOffset.y + insets.top))
                cancelButton.transform = CGAffineTransform(scaleX: -(scrollView.contentOffset.y + insets.top)/100, y: -(scrollView.contentOffset.y + insets.top)/100)
            }
            //trigger the cancel action if past a certain point
            if scrollView.contentOffset.y <= -130 {
                if !cancelTriggered {
                    cancelTriggered = true
                    cancel()
                }
            }
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == cellCount - 1 { //if the selected row is the add row.
            //also note that indexPath.section is used rather than indexPath.row
            let cell: AddButton = self.tableView.dequeueReusableCell(withIdentifier: addButtonCellReuseIdentifier) as! AddButton// add button will be a normal cell
            var bgColor: UIColor
            var textColor: UIColor
            if cellCount == maxCellCount {
                bgColor = cell.greyBG
                textColor = cell.greyText
            } else {
                bgColor = cell.normalBGColor
                textColor = cell.normalTextColor
            }
            cell.configure(BGColor: bgColor, TextColor: textColor) //refer to decision file
            print("CREATED addButton at index: \(indexPath.section)")
            return cell
        } else if indexPath.section == 0 {
            
            let cell: QuestionBar = self.tableView.dequeueReusableCell(withIdentifier: questionBarCellReuseIdentifier) as! QuestionBar// add button will be a normal cell
            if let placeholder = cell.textViewPlaceholder {
                placeholder.removeFromSuperview()
            }
            cell.decisionHandler = decision
            cell.configure(text: decision.getTitle()) //refer to decision file
            print("CREATED questionBar at index: \(indexPath.section), with question: \(decision.getTitle() == "" ? "\"\"" : decision.getTitle())")
            return cell
        } else { //if it's not the add item button
            let cell: DecisionItem = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DecisionItem //cast to decisionitem
            if let placeholder = cell.textViewPlaceholder {
                placeholder.removeFromSuperview()
            }
            cell.decisionHandler = decision
            let text = decision.getDecision(at: indexPath.section)
            cell.configure(text: text)
            print("CREATED decisionItem at index: \(indexPath.section), with description: \(text == "" ? "\"\"" : text)")
            return cell
        }
    }
    // method to run when table view cell is tapped, used for add button here
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        if indexPath.section == cellCount - 1 { //if it's the last cell, usually the add button but not always...
            print("TAPPED addButton at index: \(indexPath.section)")
            let index = IndexSet([indexPath.section])
            if cellCount < maxCellCount { //decision cells + add button <= maxCellCount
                UIView.animate(withDuration: 0.15, delay: 0, animations: {
                    self.tableView.beginUpdates()
                    self.cellCount += 1
                    self.tableView.insertSections(index, with: .fade) //insert a section right above the add button with a top down animation
                    print("ADDED section at index: \(indexPath.section)")
                    self.decision.add(decision: "")
                    self.tableView.endUpdates()
                    print("Data: \(self.decision.decisionItemList)")
                    if self.cellCount == self.maxCellCount {
                        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.cellCount - 1)) as? AddButton {
                            cell.fadeToGrey()
                        }
                    }
                }, completion: nil)
            } else {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.cellCount - 1)) as? AddButton {
                    cell.shake()
                }
            }
        } else if indexPath.section == 0 {
            print("TAPPED questionBar at index: \(indexPath.section)")
        } else {
            print("TAPPED decisionItem at index: \(indexPath.section)")
        }
    }
    //prevents deleting of add button or questionbar
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !(indexPath.section == cellCount - 1 || indexPath.section == 0)
    }
    
    //handles deletion of rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = IndexSet([indexPath.section])
        if editingStyle == .delete {
            if cellCount > 4 { //allow deletion as long as there will be 3 cells afterwards
                let beforeSize = self.tableView.contentSize
                let beforeContentOffset = self.tableView.contentOffset
                print("Before size: \(beforeSize)")
                print("Before offset: \(beforeContentOffset)")
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    
                    self.tableView.beginUpdates()
                    self.cellCount -= 1
                    self.tableView.deleteSections(index, with: .right)
                    self.decision.removeDecision(at: indexPath.section)
                    self.tableView.endUpdates()
                    print("REMOVED decisionItem at index: \(indexPath.section)")
                    print("Data: \(self.decision.decisionItemList)")
                    
                }, completion: { finished in //ensures that color change happens AFTER cell removal
                    if self.cellCount == self.maxCellCount - 1 { //if it was previously greyed due to too many cells, make add button white again
                        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.cellCount - 1)) as? AddButton {
                            cell.fadeToNormal()
                        }
                    }
                })
            } else {
                if let cell = tableView.cellForRow(at: indexPath) as? DecisionItem {
                    cell.shakeError() //DOESNT WORK
                }
            }
        }
    }
    //animates highlighting of addbutton
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if indexPath.section == cellCount - 1 && cellCount != maxCellCount {
            if let cell = tableView.cellForRow(at: indexPath) as? AddButton {
                UIView.animate(withDuration: 0.2, animations: {
                    cell.backgroundColor = cell.greyBG
                })
            }
        }
    }
    //animates highlighting of addbutton
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if indexPath.section == cellCount - 1 && cellCount != maxCellCount {
            if let cell = tableView.cellForRow(at: indexPath) as? AddButton {
                UIView.animate(withDuration: 0.2, animations: {
                    cell.backgroundColor = cell.normalBGColor
                })
            }
        }
    }
    //the height of the post
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == cellCount - 1 {
            return 30 //the add button is this height
        } else {
            return UITableView.automaticDimension
        }
    }
    //right swipe
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addPicture = UIContextualAction(style: .normal, title:  "Add picture", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Add picture")
        })
        addPicture.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [addPicture])
    }
    //closes popup
    func closePopup() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.popup.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: nil)
        
        UIView.transition(with: popup, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.popup.alpha = 0
            self.dimBackground.alpha = 0
        }, completion: { finished in
            self.popup.isHidden = true
//            self.dimBackground.isHidden = true
        })
    }
    //opens popup
    func showPopup() {
        self.popup.isHidden = false
        self.dimBackground.isHidden = false
        UIView.transition(with: popup, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.popup.alpha = 1
            self.dimBackground.alpha = 0.5
        }, completion: nil )
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.popup.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
   func showTagPopup() {
        self.tagPopup.isHidden = false
        self.dimBackground.isHidden = false
        UIView.transition(with: tagPopup, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.tagPopup.alpha = 1
            self.dimBackground.alpha = 0.5
        }, completion: nil )
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.tagPopup.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    func closeTagPopup() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.tagPopup.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: nil)
        
        UIView.transition(with: tagPopup, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.tagPopup.alpha = 0
            self.dimBackground.alpha = 0
        }, completion: { finished in
            self.tagPopup.isHidden = true
            self.dimBackground.isHidden = true
        })
    }
    //dismisses the popup
    @objc func cancelPopup(_ sender: Any) {
        cancelTriggered = false
        closePopup()
    }
    @objc func moveToTags(_ sender: Any) {
       
            self.closePopup()
            self.showTagPopup()
       
    }
    //saves the decision
    @objc func saveDecision(_ sender: Any) {
        cancelTriggered = false
        closeTagPopup()
        print("DECISION SAVED")
        print("Title: \(self.decision.getTitle())")
        print("Content: ")
        for section in 1..<self.cellCount - 1 { //saving each cell
            print("\(self.decision.getDecision(at: section))")
        }
        // upload the decision data to firebase
        let ref = Database.database().reference().root
        guard let userKey = Auth.auth().currentUser?.uid else {return}
        
        var post_options = self.decision.decisionItemList
        // removes the first element because it is the question
        post_options.remove(at: 0)
        
        //creating an array for voting
        var votes: [Int] = []
        for _ in 0..<post_options.count {
            votes.append(0)
        }
        
        //dictionary uploaded to firebase for the post
        let postData = [
            "title": self.decision.getTitle(),
            "options": post_options,
            "owner": userKey,
            "votes": votes,
            ] as [String : Any]
        
        let newPostKey = ref.child("posts").childByAutoId().key
        //store the post under the posts branch
        ref.child("posts").child(newPostKey!).setValue(postData)
        //stores the child ID of the post into the users>posts branch
        ref.child("users").child(userKey).child("posts").child(newPostKey!).setValue(newPostKey!) //the key == the value, didn't know how else to get it to work like this.
        //animate the action of going back, switching tabs is also handled in animated
        self.dismiss(animated: true, completion: nil)
    }
    //deletes the decision
    @objc func deleteDecision(_ sender: Any) {
        closePopup()
        self.dismiss(animated: true, completion: nil)
    }
    
    //cancel button to introduce popup
    func cancel() {
        print("Initiated cancelButton")
        popup.setTitle(to: "Delete Decision")
        popup.setText(to: "Are you sure you want to delete this decision?")
        popup.changeButton1(to: button.popupCancel)
        popup.changeButton2(to: button.popupDelete)
        popup.removeAllTargets()
        popup.setButton1Target(self, #selector(cancelPopup(_:)))
        popup.setButton2Target(self, #selector(deleteDecision(_:)))
        //fade it in while also zooming in
        showPopup()
    }
    //action connected to post button
    @IBAction func save(_ sender: CustomButton) {
        var blankCellList: [Int] = [] //used to determine where the blank cells are
        
        for section in 1..<cellCount - 1 { //check to see if any are empty
            if decision.getDecision(at: section) == "" {
                blankCellList.append(section) //add its section if empty
            }
        }
        //if there are no empty cells....
        if blankCellList.count == 0 && decision.getTitle() != "" {
            popup.setTitle(to: "Post Decision")
            popup.setText(to: "Are you sure you want to post this decision?")
            popup.changeButton1(to: button.popupCancel)
            popup.changeButton2(to: button.popupPost)
            popup.removeAllTargets()
            popup.setButton1Target(self, #selector(cancelPopup(_:)))
            popup.setButton2Target(self, #selector(moveToTags(_:)))
            showPopup()
            
        } else { //otherwise...
            if blankCellList.count != 0 {
                for section in 0..<blankCellList.count {
                    if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: blankCellList[section])) as? DecisionItem {
                        cell.shakeError()
                    }
                }
            }
            if decision.getTitle() == "" {
                if let questionBar = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? QuestionBar {
                    questionBar.shakeError()
                }
            }
        }
    }
}

