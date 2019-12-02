//
//  RecentWordsTableViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 12/11/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit

class RecentWordsTableViewController: UITableViewController {
    
    let wordsCoreData = WordsCoreData()//to delete words /edit
    
    var words: Array<word> = [] //Holds the array of recent words
    

    override func viewDidLoad() {
        super.viewDidLoad()
        words = RecentlyAdded.sharedInstance.getArray() // populates the words array with the recently added words

    }
    
    override func viewWillAppear(_ animated: Bool) { //reloads the view everytime the user looks at it
        tableView.reloadData()
    }


    override func numberOfSections(in tableView: UITableView) -> Int { //returns the number of sections
        return 1
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //returns the number of rows
        
        if section == 0{
            return words.count
        } else {
            return 0
        }
        
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //populates each cell of the table
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)
        let word = words[indexPath.row]
        cell.textLabel?.text = "\(word.origin)"
        cell.detailTextLabel?.text = "\(word.translation)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //the system to understand which item is picked
        let word = words[indexPath.row]
        print("\(word.origin), \(word.translation) was picked")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { //enable swipe to delete
     if editingStyle == .delete {
        let word = words[indexPath.row]
        //print("\(word.origin), \(word.translation) was deleted")
        print(wordsCoreData.deleteWordPair(searchWord: word.origin)) //delete out of core data
        RecentlyAdded.sharedInstance.removeItem(originToRemove: word.origin) //delete out of array
        self.words.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
     }
    }
    


}
