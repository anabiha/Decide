//
//  FeedTableViewController.swift
//  Decide
//
//  Created by Daniel Wei on 11/4/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
//View controller for our feed
class FeedTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //Returns the number of rows that are to be displayed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //Stand in number as of now
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell //casting the cell as our own custom cell so we can access its data members
        cell.cellLabel?.text = "Cell Row: \(indexPath.row) Section: \(indexPath.section)"
        return cell
    }
    //This method unwinds from displaynoteviewcontroller back to this tableviewcontroller
    //prevents memory leaks and stack overflow
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        //method does not need implementation. Swift just needs to register this method to unwind!!
    }
    //prepares the view to segue into another view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        guard let identifier = segue.identifier else { return }
        
        // 2
        switch identifier {
        case "add":
            print("add button tapped")
            
        default:
            print("unexpected segue identifier")
        }
    }
}
