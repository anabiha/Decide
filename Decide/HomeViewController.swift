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
                var total = post.getTotal()
//                var sumOfPercentFloors: Int = 0
//                for i in 0..<post.numVotes.count {
//                    sumOfPercentFloors += Int(Double(post.numVotes[i])/Double(total) * 100)
//                    listOfFloors.append(Int(Double(post.numVotes[i])/Double(total) * 100))
//                    listOfPercents.append(Double(post.numVotes[i])/Double(total) * 100)
//                }
//                var sortListOfFloors = listOfFloors
//                var diff = 100 - sumOfPercentFloors
//                //bubblesort
//                for i in stride(from: listOfPercents.count - 1, to: -1, by: -1) {
//                    for j in stride(from: 1, to: i + 1, by: +1) {
//                        //sort by decimal places
//                        if (listOfPercents[j - 1] - Double(sortedListOfFloors[j]) < listOfPercents[j] - Double(sortedListOfFloors[j])) {
//                            let temp1 = sortedListOfFloors[j-1]
//                            sortedListOfFloors[j-1] = sortedListOfFloors[j]
//                            sortedListOfFloors[j] = temp1
//                            let temp2 = sortedListOfPercents[j-1]
//                            sortedListOfPercents[j-1] = sortedListOfPercents[j]
//                            sortedListOfPercents[j] = temp2
//                        }
//                    }
//                }
//                var counter = 0
//                while diff > 0 {
//                    if counter >= listOfFloors.count { counter = 0 }
//                    listOfFloors[counter] += 1
//                    counter += 1
//                    diff -= 1
//                }
//                //problem, list of floors is getting sorted, which messes up the order of the percentages
//                print(listOfFloors)
//                print(listOfPercents)
                if indexPath.row == post.decisions.count + 1 { //rounds corners of bottom row
                    cell.shouldRound = true
                } else {
                    cell.shouldRound = false
                }
                //configure cell with the correct percentage
                //change percentage to a decimal
               
                var color: UIColor!
                if let vote = post.getUserVote() { //if the post was voted on, we have to highlight what that vote was...
                    if vote + 2 == indexPath.row && !post.didDisplay {
                        color = cell.color2
                    } else {
                        color = cell.color1
                    }
                } else {
                    color = cell.color1
                }
                cell.configure(text: post.decisions[indexPath.row - 2], percentage: Double(post.numVotes[indexPath.row - 2])/Double(total), color: color)
                if post.didDisplay { //redisplay percentages if they were shown prior
                    cell.displayPercentage()
                }
            }
            return cell
        }
    }
    //animates highlighting of selection
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if indexPath.row > 1 {
            if let cell = tableView.cellForRow(at: indexPath) as? ChoiceCell {
                let post = homeDecision.getPost(at: indexPath.section)
                if post!.isVoteable {
                    UIView.animate(withDuration: 0.2, animations: {
                        cell.backgroundColor = cell.color2
                    })
                }
            }
        }
    }
    //animates highlighting of selection
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if indexPath.row > 1 {
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
//                    if let cell = self.tableView.cellForRow(at: indexPath) as? ChoiceCell {
//                        cell.backgroundColor = cell.color2
//                    }
                } //add a vote to the decision
                post.didDisplay = !post.didDisplay //mark the cell as displayed, regardless of whether whole post is visible, switch it each time it is pressed
                
                for index in 2..<post.decisions.count + 2 {
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: indexPath.section)) as? ChoiceCell {
                        cell.updatePercent(newPercent: post.getPercentage(forDecisionAt: index - 2)) //retrieve the updated percentage and display it
                        
                        if post.didDisplay {
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
