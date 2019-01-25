//
//  NewDecisionViewController.swift
//  Decide
//
//  Created by Daniel Wei on 11/4/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit

class NewDecisionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var decisionTitle: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var descriptions: [String] = []
    var decision = Decision()
    var decisionItemCount = 2;
    let cellReuseIdentifier = "decisionItemCell"
    let addButtonCellReuseIdentifier = "addButtonCell"
    let cellSpacingHeight: CGFloat = 12
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
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: tableView.frame.size.height - 300, right: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return decisionItemCount
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
        if indexPath.section == decisionItemCount - 1 { //if the selected row is the add row. also note that indexPath.section is used rather than indexPath.row
            print("Add button created")
            let cell: AddButton = self.tableView.dequeueReusableCell(withIdentifier: addButtonCellReuseIdentifier) as! AddButton// add button will be a normal cell
            cell.configure() //refer to decision file
            return cell
        } else { //if it's not the add item button.... (basically everything else)
            //FIX
            print("DecisionItem created")
            let cell: DecisionItem = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DecisionItem //cast to decisionitem
            let index = indexPath.section
            if descriptions.count < index + 1 {
               descriptions.append(cell.descriptionBox.text)
            } else {
                descriptions[index] = cell.descriptionBox.text
            }
           //FIX THIS...TRYING TO APPEND OLD TEXT TO DESCRIPTIONS
            cell.configure(text: descriptions[indexPath.section]) //refer to decision file
            return cell
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        if indexPath.section == decisionItemCount - 1 { //if it's the add button,
            print("You tapped the add button located at: \(indexPath.section).")
            UIView.animate(withDuration: 0.15, delay: 0.00, options: .curveEaseIn, animations: {
                self.tableView.beginUpdates()
                self.decisionItemCount += 1
                let index = IndexSet([indexPath.section])
                self.tableView.insertSections(index, with: .none) //insert a section right above the add button with a top down animation
                self.tableView.endUpdates()
                
                //scrolls to bottom if there are too many rows to fit on screen
                //FIX FIX FIX, need to find a way to find height of the tableview currently on screen
                if (tableView.contentSize.height > UIScreen.main.bounds.size.height -  (self.navigationController?.navigationBar.frame.size.height)!) {
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                
            })
        } else {
            print("You tapped a decision item row located at: \(indexPath.section).")
        }
    }
  
    //handles deletion of rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = IndexSet([indexPath.section])
        if editingStyle == .delete && indexPath.section != decisionItemCount - 1 {
            descriptions.remove(at: indexPath.section)
            self.tableView.beginUpdates()
            decisionItemCount -= 1
            self.tableView.deleteSections(index, with: .none)
            self.tableView.endUpdates()
        }
    }
    //the height of the post, to be implemented later
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.section == decisionItemCount - 1 {
            return 25 //the add button is this height
         } else {
            return UITableView.automaticDimension
        }
    }
    
    //the action called when the cancel button is pressed
    @IBAction func cancel(_ sender: Any) {
        let index = (self.tabBarController as! MainTabBarController).previouslySelectedIndex!
        descriptions = []
        //animate action of going back, switching tabs is also handled in animate
        animateToTab(toIndex: index) //changing of tab bar item is handled here as well
    }
    //action called when the save button is pressed
    //saves all the cell information NOT DONE
    @IBAction func save(_ sender: Any) {
        for section in 0..<decisionItemCount { //saving each cell
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: section)) as! DecisionItem
            decision.decisionItemList.append(cell)
        }
        //animate the action of going back, switching tabs is also handled in animated
        animateToTab(toIndex: 0) //changing of tab bar item is handled here as well
    }
}

