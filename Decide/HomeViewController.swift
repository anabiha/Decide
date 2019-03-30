//
//  HomeViewController.swift
//  Decide
//
//  Created by Daniel Wei on 11/9/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let usernameIdentifier = "userCell"
    let titleIdentifier = "titleCell"
    let choiceIdentifier = "choiceCell"
    let cellSpacingHeight: CGFloat = 10
    let homeDecision = HomeDecision()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView() //hides unused cells
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        self.view.backgroundColor = UIColor(red:245/255, green: 245/255, blue: 245/255, alpha: 1)
        homeDecision.configure()
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
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: usernameIdentifier) as! UserCell
            cell.configure(username: "USER")
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: titleIdentifier) as! HomeTitleCell
            if let post = homeDecision.getPost(at: indexPath.section) {
                cell.configure(text: post.title)
            }
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: choiceIdentifier) as! ChoiceCell
           
            print("CREATED CHOICECELL at \(indexPath)")
            if let post = homeDecision.getPost(at: indexPath.section) {
                cell.configure(text: post.decisions[indexPath.row - 2], percentage: post.percentages[indexPath.row - 2])
                if post.didDisplay { //redisplay percentages if they were shown prior
                    cell.displayPercentage()
                }
            }
            return cell
        }
    }
    
    //display all rows of section if one is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        print("You tapped cell number \(indexPath.row). at post number: \(indexPath.section)")
        if indexPath.row != 0 && indexPath.row != 1 {
            if let post = homeDecision.getPost(at: indexPath.section) {
                post.didDisplay = true //mark the cell as displayed
                for index in 2..<post.decisions.count + 2 {
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: indexPath.section)) as? ChoiceCell {
                        cell.displayPercentage()
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
