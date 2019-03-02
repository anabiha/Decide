//
//  NewDecisionViewController.swift
//  Decide
//
//  Created by Daniel Wei on 11/4/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit

class PostButton: UIButton {
    let normalBGColor = UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 0.6)
    let selectedBGColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    public func configure() {
        backgroundColor = normalBGColor
        layer.cornerRadius = 12
        setTitle("Post", for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.lightGray, for: .highlighted)
        titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
    }
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? selectedBGColor : normalBGColor
        }
    }
}
class NewDecisionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postButton: PostButton!
    var justAdded: Bool = false
    var decision = Decision()
    var cellCount = 4 //current number of cells, start at 3
    let maxCellCount = 8 //max number of cells, should be an even number
    let cellReuseIdentifier = "decisionItemCell"
    let addButtonCellReuseIdentifier = "addButtonCell"
    let questionBarCellReuseIdentifier = "questionBarCell"
    let decisionItemOffset: Int = 1
    let cellSpacingHeight: CGFloat = 14
    
    
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
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        self.view.backgroundColor = UIColor(red:250/255, green: 250/255, blue: 250/255, alpha: 1)
        //makes navigation bar clear
        postButton.configure()
        decision.configure(withSize: cellCount)
    }
  
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
            cell.configure(text: text, index: indexPath.section)
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
                justAdded = true
                UIView.animate(withDuration: 0.15, delay: 0, animations: {
                    self.tableView.beginUpdates()
                    self.cellCount += 1
                    self.tableView.insertSections(index, with: .fade) //insert a section right above the add button with a top down animation
                    print("ADDED section at index: \(indexPath.section)")
                    self.decision.insertDecision(at: indexPath.section, with: "")
                    self.tableView.endUpdates()
                    if self.cellCount == self.maxCellCount {
                        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.cellCount - 1)) as? AddButton {
                            cell.fadeToGrey()
                        }
                    }
                }, completion: nil)
                
            } //don't add anything if cell count > maxCellCount
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
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    self.tableView.beginUpdates()
                    self.cellCount -= 1
                    self.tableView.deleteSections(index, with: .right)
                    self.decision.removeDecision(at: indexPath.section)
                    self.tableView.endUpdates()
                }, completion: { finished in //ensures that color change happens AFTER cell removal
                    if self.cellCount == self.maxCellCount - 1 { //if it was previously greyed due to too many cells, make add button white again
                        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.cellCount - 1)) as? AddButton {
                            cell.fadeToNormal()
                        }
                    }
                })
                print("REMOVED decisionItem at index: \(indexPath.section)")
               
            } else {
                    if let cell = tableView.cellForRow(at: indexPath) as? DecisionItem {
                        cell.shakeError() //DOESNT WORK
                }
            }
        }
    }
    //the height of the post
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.section == cellCount - 1 {
            return 25 //the add button is this height
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
    @IBAction func cancel(_ sender: UIButton) {
        print("Pressed cancelButton")
        let index = (self.tabBarController as! MainTabBarController).previouslySelectedIndex!
        //animate action of going back, switching tabs is also handled in animate
        animateToTab(toIndex: index) //changing of tab bar item is handled here as well
    }
    
    @IBAction func save(_ sender: PostButton) {
        var blankCellList: [Int] = []
        
        for section in 1..<cellCount - 1 { //check to see if any are empty
            if decision.getDecision(at: section) == "" {
                blankCellList.append(section) //add its section if empty
            }
        }
        //find a way to send the decision to profileviewcontroller, maybe a segue
        if blankCellList.count == 0 && decision.getTitle() != "" {
            print("DECISION SAVED")
            print("Title: \(decision.getTitle())")
            print("Content: ")
            for section in 1..<cellCount - 1 { //saving each cell
                print("\(decision.getDecision(at: section))")
            }
            //animate the action of going back, switching tabs is also handled in animated
            animateToTab(toIndex: 0) //changing of tab bar item is handled here as well
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
    
    //the action called when the cancel button is pressed
    
    //action called when the save button is pressed
    //saves all the cell information NOT DONE
  
   
}

