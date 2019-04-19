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
    let cellSpacingHeight: CGFloat = 40
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
        if indexPath.row == 0 { //username/profile pic bar
            let cell = self.tableView.dequeueReusableCell(withIdentifier: usernameIdentifier) as! UserCell
            cell.configure(username: "USER")
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 { //title bar
            let cell = self.tableView.dequeueReusableCell(withIdentifier: titleIdentifier) as! HomeTitleCell
            if let post = homeDecision.getPost(at: indexPath.section) {
                cell.configure(text: post.title)
            }
            return cell
        } else { //choice bars
            let cell = self.tableView.dequeueReusableCell(withIdentifier: choiceIdentifier) as! ChoiceCell
            print("CREATED CHOICECELL at \(indexPath)")
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
                            color = cell.color1
                        } else {
                            color = cell.color2
                        }
                    }
                } else {
                    color = cell.color1 //everything remains color1 if nothing was voted
                }
                let total = post.getTotal()
                cell.configure(text: post.decisions[indexPath.row - 2], percentage: Double(post.numVotes[indexPath.row - 2])/Double(total), color: color)
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
                                if vote + 2 != index {
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
