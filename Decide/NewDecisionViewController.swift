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
    
    var decisionItemCount = 2;
    let cellReuseIdentifier = "decisionItemCell"
    let addButtonCellReuseIdentifier = "addButtonCell"
    let cellSpacingHeight: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DO NOT REGISTER THE CELL CLASSES HERE, ALREADY DONE IN INTERFACEBUILDER!!!!!!!
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
            cell.configure()
            return cell
            
        } else { //if it's not the add item button.... (basically everything else)
            print("DecisionItem created")
            let cell: DecisionItem = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DecisionItem //cast to decisionitem
            cell.configure(text: "", placeholder: "Type something!")
         
            return cell
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        if indexPath.section == decisionItemCount - 1 { //if it's the add button,
            print("You tapped the add button located at: \(indexPath.section).")
            self.tableView.beginUpdates()
            decisionItemCount += 1
            let index = IndexSet([indexPath.section])
            self.tableView.insertSections(index, with: .none) //insert a section right above the add button with a top down animation
            self.tableView.endUpdates()
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
        let index = 0
        animateToTab(tabBarController: self.tabBarController!, to: self.tabBarController!.viewControllers![index])
        self.tabBarController?.selectedIndex = index
    }
    //handles animating back to original view
    func animateToTab(tabBarController: UITabBarController, to viewController: UIViewController){
        let fromView = tabBarController.selectedViewController?.view
        let toView = viewController.view
        
        if fromView != toView {
            UIView.transition(from: fromView!, to: toView!, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
      //HAVE TO CHANGE THIS ANIMATION!!!
    }
}
