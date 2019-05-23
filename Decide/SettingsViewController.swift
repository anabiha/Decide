//
//  SettingsViewController.swift
//  Decide
//
//  Created by Daniel Wei on 5/13/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//perform segue
class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.estimatedRowHeight = 43.5
        tableview.backgroundColor = UIColor.clear
        tableview.rowHeight = UITableView.automaticDimension
        tableview.tableFooterView = UIView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.isScrollEnabled = false
        tableview.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        tableview.separatorStyle = .none
        return tableview
    }()
    var homeTab: UIView = {
        let homeTab = UIView()
        homeTab.translatesAutoresizingMaskIntoConstraints = false
        homeTab.backgroundColor = Universal.viewBackgroundColor
        homeTab.layer.cornerRadius = 30
        homeTab.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        return homeTab
    } ()//the tab that acts as a slice of the home view
    let homeTabText: UILabel = {
        let homeTabText = UILabel()
        homeTabText.translatesAutoresizingMaskIntoConstraints = false
        homeTabText.textColor = UIColor.black
        homeTabText.font = UIFont(name: Universal.heavyFont, size: 30)
        homeTabText.alpha = 0
        return homeTabText
    }()
    var insets = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
    let homeTabWidth: CGFloat = 80 //the width of the home tab
    let vibration = UIImpactFeedbackGenerator(style: Universal.vibrationStyle)
    var dragToHome: UIGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
        
        view.addSubview(tableview)
        view.addSubview(homeTab)
        homeTab.addSubview(homeTabText)
        //constraints
        let tableviewWidth = UIScreen.main.bounds.width - homeTabWidth
        let center = (UIScreen.main.bounds.width - homeTabWidth)/2 //the center of the region between tab and leading anchor
        tableview.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        tableview.widthAnchor.constraint(equalToConstant: tableviewWidth).isActive = true
        tableview.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: center).isActive = true
        tableview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        homeTab.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeTab.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        homeTab.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        homeTab.widthAnchor.constraint(equalToConstant: homeTabWidth).isActive = true
        homeTabText.centerXAnchor.constraint(equalTo: homeTab.centerXAnchor).isActive = true
        homeTabText.centerYAnchor.constraint(equalTo: homeTab.centerYAnchor).isActive = true
        homeTabText.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        view.backgroundColor = UIColor.white
        //gesture recognizer
        dragToHome = UIPanGestureRecognizer(target: self, action: #selector(wasDraggedToHome(gestureRecognizer:)))
        view.addGestureRecognizer(dragToHome)
    }
    override func viewDidAppear(_ animated: Bool) {
        if dragToHome != nil {
            dragToHome.isEnabled = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let offset = UIScreen.main.bounds.width/2
        self.tableview.center = CGPoint(x: self.tableview.center.x - offset, y: self.tableview.center.y)
        UIView.animate(withDuration: 0.35, delay: 0.08, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
            self.tableview.alpha = 1
            self.tableview.center = CGPoint(x: self.tableview.center.x + offset, y: self.tableview.center.y)
        }, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        homeTabText.alpha = 0
    }
    //used for switching back to home page
    @objc func wasDraggedToHome(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.view)
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            vibration.impactOccurred()
        }
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            let minDist = UIScreen.main.bounds.width/4
            if gestureRecognizer.view!.frame.minX + translation.x < 0 {
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y)
                gestureRecognizer.setTranslation(.zero, in: view)
                if gestureRecognizer.view!.frame.minX + translation.x < -minDist {
                    if let tb = tabBarController as? MainTabBarController {
                        gestureRecognizer.isEnabled = false
                        tb.animateTabSwitch(to: 0, withScaleAnimation: false)
                    }
                }
            }
        } else if gestureRecognizer.state == UIGestureRecognizer.State.ended { //reset the frame if it didnt get dragged the minimum distance
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin = .zero
            }, completion: { finished in
                self.vibration.impactOccurred()
            })
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel!.textColor = UIColor.black
        cell.textLabel!.textAlignment = .center
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0: //the logo
            cell.textLabel!.font = UIFont(name: Universal.heavyFont, size: 30)
            cell.textLabel!.text = "Decide"
        case 1:
            cell.textLabel!.font = UIFont(name: Universal.lightFont, size: 20)
            cell.textLabel!.text = "Account"
        default:
            cell.textLabel!.text = "ERROR"
        }
        return cell
    }
}
