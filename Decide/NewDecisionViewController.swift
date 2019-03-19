//
//  NewDecisionViewController.swift
//  Decide
//
//  Created by Daniel Wei on 11/4/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
import Firebase

struct button {
    static let post = (UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Post")
    static let popupCancel = (UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1), UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1), UIColor.black, UIColor.black,"Cancel")
    static let popupDelete = (UIColor(red: 244/255, green: 66/255, blue: 66/255, alpha: 0.8), UIColor(red: 216/255, green: 41/255, blue: 41/255, alpha: 0.8), UIColor.white, UIColor.white, "Delete")
    //59, 237, 118
    static let popupPost = (UIColor(red: 59/255, green: 230/255, blue: 115/255, alpha: 1), UIColor(red: 29/255, green: 209/255, blue: 80/255, alpha: 1), UIColor.white, UIColor.white, "Post")
}

//class that instantiates buttons based on the tuple passed in
class CustomButton: UIButton {
    var normalBGColor: UIColor = UIColor.black
    var selectedBGColor: UIColor = UIColor.black
    //normal bg color, highlighted bg color, normal text color, highlighted text color, title
    public func configure(tuple: (UIColor, UIColor, UIColor, UIColor, String)) {
        backgroundColor = tuple.0
        setTitleColor(tuple.2, for: .normal)
        setTitleColor(tuple.3, for: .highlighted)
        setTitleColor(tuple.3, for: .selected)
        setTitle(tuple.4, for: .normal)
        titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        layer.cornerRadius = 12
        
        self.normalBGColor = tuple.0
        self.selectedBGColor = tuple.1
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundColor = self.isHighlighted ? self.selectedBGColor : self.normalBGColor
            })
        }
    }
}

class NewDecisionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postButton: CustomButton!
    @IBOutlet weak var cancelButton: UIButton!
//
    @IBOutlet weak var cancelButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonWidth: NSLayoutConstraint!

    
    @IBOutlet weak var cancelPopup: UIView!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupText: UILabel!
    @IBOutlet weak var popupButtonLeft: CustomButton!
    @IBOutlet weak var popupButtonRight: CustomButton!
    
    @IBOutlet weak var dimBackground: UIView!
    
    var cancelTriggered: Bool = false
    var selectedIndex = 0
    var decision = Decision() //data manager
    var insets: UIEdgeInsets = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0) //content inset for tableview
    var cellCount = 4 //current number of cells, start at 4
    let maxCellCount = 8 //max number of cells, should be an even number
    let cellReuseIdentifier = "decisionItemCell" //reuse identifiers
    let addButtonCellReuseIdentifier = "addButtonCell"
    let questionBarCellReuseIdentifier = "questionBarCell"
    let cellSpacingHeight: CGFloat = 14
    let screenSize = UIScreen.main.bounds
    var defaultCancelFrame: CGRect?
    //Background is an IMAGEVIEW
    override func viewDidLoad() {
        super.viewDidLoad()
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
        configurePopup("cancel")
        
        //configure decision object with cells
        decision.configure(withSize: cellCount - 1)
        //the dim background for popup
        dimBackground.alpha = 0
        dimBackground.isHidden = true
        dimBackground.backgroundColor = UIColor.black
        //view controller is behind dim background which is behind the popup
        self.view.bringSubviewToFront(dimBackground)
        self.view.bringSubviewToFront(cancelPopup)
        //add keyboard observer, allows for actions when keyboard appears/disappears
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        defaultCancelFrame = cancelButton.frame
    }
    //tells cells how large keyboard will be
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
    //configures the popup
    public func configurePopup(_ type: String) {
        popupTitle.font = UIFont(name: "AvenirNext-DemiBold", size: 19)
        popupText.font = UIFont(name: "AvenirNext-Medium", size: 17)
        popupText.textColor = UIColor.lightGray
        popupText.numberOfLines = 2
        cancelPopup.alpha = 0
        cancelPopup.backgroundColor = UIColor.white
        cancelPopup.layer.cornerRadius = 15
        cancelPopup.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        cancelPopup.isHidden = true
        
        switch type {
        case "cancel":
            popupButtonLeft.configure(tuple: button.popupCancel)
            popupButtonRight.configure(tuple: button.popupDelete)
            popupTitle.text = "Delete Decision"
            popupText.text = "Are you sure you want to delete this decision?"
        case "post":
            popupButtonLeft.configure(tuple: button.popupCancel)
            popupButtonRight.configure(tuple: button.popupPost)
            popupTitle.text = "Post Decision"
            popupText.text = "Are you sure you want to post this decision?"
        default:
            print("ERROR: switch statement for popup triggered")
        }
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
            if scrollView.contentOffset.y <= -110 {
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
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addPicture = UIContextualAction(style: .normal, title:  "Add picture", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Add picture")
        })
        addPicture.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [addPicture])
    }
    
    //popup that either saves the decision or cancels the post, depends on configuration
    @IBAction func popupRight(_ sender: Any) {
        cancelTriggered = false
        UIView.animate(withDuration: 0.15, delay: 0, options: .transitionCrossDissolve, animations: {
            self.cancelPopup.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: nil)
        UIView.transition(with: self.cancelPopup, duration: 0.15, options: .transitionCrossDissolve, animations: {
            self.cancelPopup.alpha = 0
            self.dimBackground.alpha = 0
        }, completion: { finished in
            self.cancelPopup.isHidden = true
            self.dimBackground.isHidden = true
            if self.popupTitle.text == "Post Decision" { //if the rightbutton was a post button....
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
                
                ref.child("posts").child(userKey).child("").child("Options").setValue(post_options)
                ref.child("posts").child(userKey).child("").child("Title").setValue(self.decision.getTitle())
                //animate the action of going back, switching tabs is also handled in animated
                self.animateToTab(toIndex: 0) //changing of tab bar item is handled here as well
            } else { //if the right button wasn't a post button....
                let index = (self.tabBarController as! MainTabBarController).previouslySelectedIndex!
                self.animateToTab(toIndex: index)
            }
        })
        
        
    }
    //animation to dismiss popup
    @IBAction func popupLeft(_ sender: Any) {
        cancelTriggered = false
        UIView.animate(withDuration: 0.15, delay: 0, options: .transitionCrossDissolve, animations: {
            self.cancelPopup.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: nil)
        
        UIView.transition(with: self.cancelPopup, duration: 0.15, options: .transitionCrossDissolve, animations: {
            self.cancelPopup.alpha = 0
            self.dimBackground.alpha = 0
        }, completion: { finished in
            self.cancelPopup.isHidden = true
            self.dimBackground.isHidden = true
        })
        
    }
    //cancel button to introduce popup
    func cancel() {
        
        print("Initiated cancelButton")
        configurePopup("cancel")
        self.cancelPopup.isHidden = false
        self.dimBackground.isHidden = false
        //fade it in while also zooming in
        UIView.transition(with: cancelPopup, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.cancelPopup.alpha = 1
            self.dimBackground.alpha = 0.5
        }, completion: nil )
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.cancelPopup.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    
    @IBAction func save(_ sender: CustomButton) {
        var blankCellList: [Int] = [] //used to determine where the blank cells are
        
        for section in 1..<cellCount - 1 { //check to see if any are empty
            if decision.getDecision(at: section) == "" {
                blankCellList.append(section) //add its section if empty
            }
        }
        //if there are no empty cells....
        if blankCellList.count == 0 && decision.getTitle() != "" {
            configurePopup("post")
            self.cancelPopup.isHidden = false
            self.dimBackground.isHidden = false
            //present popup
            UIView.transition(with: cancelPopup, duration: 0.1, options: .transitionCrossDissolve, animations: {
                self.cancelPopup.alpha = 1
                self.dimBackground.alpha = 0.5
            }, completion: nil )
            UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
                self.cancelPopup.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        } else {
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

