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
    
    var decision = Decision()
    var decisionItemCount = 2;
    let cellReuseIdentifier = "decisionItemCell"
    let addButtonCellReuseIdentifier = "addButtonCell"
    let cellSpacingHeight: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        if indexPath.section == decisionItemCount - 1 { //if the selected row is the add row. note that indexPath.section is used rather than indexPath.row
            let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: addButtonCellReuseIdentifier) as UITableViewCell! // add button will be a normal cell
            
            //addbutton aesthetics
            cell.textLabel?.text = "+ Add an item"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
            cell.textLabel?.textAlignment = .center
            // add border and color
            let grayColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)//custom color (pretty light gray)
            cell.backgroundColor = grayColor
            cell.layer.borderColor = grayColor.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
            
            return cell
            
        } else { //if it's not the add item button.... (basically everything else)
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DecisionItem //cast to decisionitem
            cell.backgroundColor = UIColor.white
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
            return cell
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        print("You tapped cell number \(indexPath.section).")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //the height of the post, to be implemented later
        return 50
    }
}
