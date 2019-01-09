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
    
    let cellReuseIdentifier = "feedCell"
    let cellSpacingHeight: CGFloat = 15
    override func viewDidLoad() {
       super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Table View delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
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
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // note that indexPath.section is used rather than indexPath.row
//        cell.textLabel?.text = "100"
        
        // add border and color
        let grayColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)//custom color (pretty light gray)
        cell.backgroundColor = grayColor
        cell.layer.borderColor = grayColor.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
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
