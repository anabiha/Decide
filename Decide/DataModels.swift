//
//  DataModels.swift
//  Decide
//
//  Created by Daniel Wei on 5/1/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
//data structure for the decisions displayed on the home page
class HomeDecision {
    //each post has a title, decisions, and percentages for those decisions
    class Post {
        var title: String! //the title or question
        var decisions: [String]! //the decisions
        var numVotes: [Int]! //distribution of votes
        var totalVotes: Int!
        var didDisplayPercents = false //marks whether cell was clicked on or not
        var isVoteable = true
        var userVote: Int? // locally keeps track of which option this specific user has voted
        var username: String?
        var key: String! //unique key for the post, used for referencing Firebase
        var popup = Popup()
        var flagHandler: FlagHandler!
        init(title: String, decisions: [String], numVotes: [Int], flagHandler: FlagHandler, key: String) {
            self.title = title
            self.decisions = decisions
            self.numVotes = numVotes
            self.key = key
            self.flagHandler = flagHandler
            recalculateTotal()
        }
        
        func getPercentage(forDecisionAt index: Int) -> Double {
            if index >= 0 && index < numVotes.count {
                return Double(numVotes[index])/Double(totalVotes)
            } else {
                print("Post;getPercentage(): INVALID accessing, Index \(index) vs Size \(numVotes.count))")
                return 0
            }
        }
        func getDecision(at index: Int) -> String {
            if index >= 0 && index < decisions.count {
                return decisions[index]
            } else {
                print("Post;getDecision(): INVALID accessing, Index \(index) vs Size \(decisions.count))")
                return ""
            }
        }
        func getVotes(at index: Int) -> Int{
            if index >= 0 && index < numVotes.count {
                return numVotes[index]
            } else {
                print("Post;getVotes(): INVALID accessing, Index \(index) vs Size \(numVotes.count))")
                return 0
            }
        }
        func getUserVote() -> Int? {
            return userVote
        }
        
        func vote(forDecisionAt index: Int) {
            if isVoteable {
                if numVotes.count > index && index >= 0{
                    numVotes[index] += 1
                    let ref = Database.database().reference()
                    ref.child("posts").child(key).child("votes").setValue(numVotes)
                    guard let UID = Auth.auth().currentUser?.uid else {return}
                    ref.child("posts").child(key).child("user-votes").child(UID).setValue(index)
                } else {
                    print("Post;vote(): INVALID accessing, Index \(index) vs Size \(numVotes.count))")
                }
            } else {
                print("Post;vote(): POST ALREADY VOTED ON")
            }
            isVoteable = false
            userVote = index
            recalculateTotal()
        }
        func getTotal() -> Int {
            return totalVotes
        }
        private func recalculateTotal() {
            totalVotes = 0
            for i in 0..<numVotes.count {
                totalVotes += numVotes[i]
            }
        }
        //tells the flaghandler that THIS is this post to be reported
        @objc func report(_ sender: Any) {
            flagHandler.post = self
        }
        
     }
    
    var posts = [Post]()
    var maxPosts: Int = 20
    
    func getPost(at index: Int) -> Post? {
        if index >= 0 && index < posts.count {
            return posts[index]
        } else {
            print("HomeDecision;getPost(): INVALID accessing, Index \(index) vs Size \(posts.count))")
            return nil
        }
    }
    
}
class FlagHandler {
    var options: [Bool] = []
    var post: HomeDecision.Post?
    func configure(length: Int) {
        options = []
        for _ in 0..<length {
            options.append(false)
        }
    }
    func numTagged() -> Int {
        var count = 0
        for i in 0..<options.count {
            if options[i] { count += 1}
        }
        return count
    }
    func isTagged(at index: Int) -> Bool {
        if index >= 0 && index < 12 {
            if options[index] {
                return true
            } else {
                return false
            }
        } else {
            print("FlagHandler;isTagged(): index out of bounds")
            return false
        }
    }
    func markTag(at index: Int) {
        if index >= 0 && index < options.count {
            if options[index] {
                options[index] = false
            } else if numTagged() < 1 {
                options[index] = true
            } else {
                print("FlagHandler;markTag(): max number of tags achieved")
            }
        } else {
            print("FlagHandler;markTag(): index out of bounds")
        }
    }
    func clear() {
        post = nil
        for i in 0..<options.count {
            options[i] = false
        }
    }
}
//data structure for a new decision
class Decision: DecisionHandler {
    
    var decisionItemList: [String] = []
    var tagList: [Bool] = []
    var activeFieldIndex: IndexPath?
    var keyboardSize: CGRect?
    func configure(withSize size: Int) {
        while decisionItemList.count < size {
            decisionItemList.append("")
        }
        for _ in 0..<12 {
            tagList.append(false)
        }
    }
    func setTitle(text: String) {
        if decisionItemList.count > 0 {
            decisionItemList[0] = text
        } else {
            decisionItemList.append(text)
        }
    }
    func totalCells() -> Int {
        return decisionItemList.count
    }
    func add(decision: String) {
        decisionItemList.append(decision)
    }
    func removeDecision(at index: Int) {
        if index > 0 && index < decisionItemList.count {
            decisionItemList.remove(at: index)
        } else {
            print("DECISION HANDLER func \"removeDecision\" TRIED TO ACCESS OUT OF BOUNDS at index: \(index)")
        }
    }
    func insertDecision(at index: Int, with decision: String) {
        if index > 0 && index < decisionItemList.count {
            decisionItemList.insert(decision, at: index)
        } else {
            print("DECISION HANDLER func \"insertDecision\" TRIED TO ACCESS OUT OF BOUNDS at index: \(index)")
        }
    }
    func setDecision(at index: Int, with decision: String) {
        if index > 0 && index < decisionItemList.count {
            decisionItemList[index] = decision
        } else {
            print("DECISION HANDLER func \"setDecision\" TRIED TO ACCESS OUT OF BOUNDS at index: \(index)")
        }
    }
    func getDecision(at index: Int) -> String {
        if index > 0 && index < decisionItemList.count {
            return decisionItemList[index]
        } else {
            print("DECISION HANDLER func \"getDecision\" TRIED TO ACCESS OUT OF BOUNDS at index: \(index)")
            return ""
        }
    }
    func getTitle() -> String {
        if decisionItemList.count > 0 {
            return decisionItemList[0]
        } else {
            print("DECISION HANLDER ATTEMPTED TO RETRIEVE A TITLE THAT DIDN'T EXIST")
            return ""
        }
    }
    func numTagged() -> Int {
        var count = 0
        for i in 0..<tagList.count {
            if tagList[i] { count += 1}
        }
        return count
    }
    func isTagged(at index: Int) -> Bool {
        if index >= 0 && index < 12 {
            if tagList[index] {
                return true
            } else {
                return false
            }
        } else {
            print("Decision;isTagged(): index out of bounds")
            return false
        }
    }
    func markTag(at index: Int) {
        if index >= 0 && index < 12 {
            if tagList[index] {
                tagList[index] = false
            } else if numTagged() < 2 {
                tagList[index] = true
            } else {
                print("Decision;markTag(): max number of tags achieved")
            }
        } else {
            print("Decision;markTag(): index out of bounds")
        }
    }
}
protocol DecisionHandler {
    func setTitle(text: String)
    func totalCells() -> Int
    func removeDecision(at index: Int)
    func insertDecision(at index: Int, with decision: String)
    func setDecision(at index: Int, with decision: String)
    func getDecision(at index: Int) -> String
}

