//
//  NewDecisionViewController.swift
//  Decide
//
//  Created by Daniel Wei on 11/4/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit

class NewDecisionViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    
    @IBOutlet weak var decisionTitle: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cellView: UIView!
    
    var decision = Decision()
    var decisionItemCount = 2;
    let cellReuseIdentifier = "decisionItemCell"
    let addButtonCellReuseIdentifier = "addButtonCell"
    let cellSpacingHeight: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //DO NOT REGISTER THE CELL CLASSES HERE, ALREADY DONE IN INTERFACEBUILDER!!!!!!!

        self.tableView.register(DecisionItem.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: addButtonCellReuseIdentifier) //this will be the addButton

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    //some function that, once tapped, saves the title and all decisions
    
   
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
            cell.configure() //refer to decision class
            return cell
            
        } else { //if it's not the add item button.... (basically everything else)
            print("DecisionItem created")
            let cell: DecisionItem = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DecisionItem //cast to decisionitem

            let grayColor2 = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)//custom color (even lighter gray)
            cell.addSubview(cell.descriptionBox)
            cell.backgroundColor = grayColor2
            cell.layer.borderColor = grayColor2.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true

            cell.configure(text: "", placeholder: "Type something!") //refer to decision class
            
            return cell
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        if indexPath.section == decisionItemCount - 1 { //if it's the add button,
            print("You tapped the add button located at: \(indexPath.section).")
            UIView.animate(withDuration: 0.2, delay: 0.15, options: .curveEaseIn, animations: {
                self.tableView.beginUpdates()
                self.decisionItemCount += 1
                let index = IndexSet([indexPath.section])
                self.tableView.insertSections(index, with: .none) //insert a section right above the add button with a top down animation
                self.tableView.endUpdates()
            })
        } else {
            print("You tapped a decision item row located at: \(indexPath.section).")
        }
    }
    //handles deletion of rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = IndexSet([indexPath.section])
        if editingStyle == .delete && indexPath.section != decisionItemCount - 1 {
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
         }  else {
            return 80
        }
    }
    
    //the action called when the cancel button is pressed
    @IBAction func cancel(_ sender: Any) {
        let index = (self.tabBarController as! MainTabBarController).previouslySelectedIndex!
        
        //animate action of going back, switching tabs is also handled in animate
        animateToTab(toIndex: index) //changing of tab bar item is handled here as well
        //self.tabBarController!.selectedIndex = index
    }
    //action called when the save button is pressed
    //saves all the cell information
    @IBAction func save(_ sender: Any) {
        for section in 0..<decisionItemCount { //saving each cell
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: section)) as! DecisionItem
            decision.decisionItemList.append(cell)
        }
        //animate the action of going back, switching tabs is also handled in animated
        animateToTab(toIndex: 0) //changing of tab bar item is handled here as well
        //reset the viewcontroller
        let vc = storyboard!.instantiateViewController(withIdentifier:"NewDecisionViewController") as! NewDecisionViewController
//        self.navigationController?.setViewControllers([vc],animated:true)
    }
    //handles animating back to original view
//    func animateToTab(toIndex: Int){
//        let fromView = self.tabBarController!.selectedViewController?.view
//        let toView = self.tabBarController!.viewControllers![toIndex].view
//
//        if fromView != toView {
//            UIView.transition(from: fromView!, to: toView!, duration: 0.3, options: [.transitionCrossDissolve], completion:nil)
//        }
//      //HAVE TO CHANGE THIS ANIMATION!!!
//    }
}

