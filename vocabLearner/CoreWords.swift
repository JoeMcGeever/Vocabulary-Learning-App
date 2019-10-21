//
//  CoreWords.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 21/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class WordsCoreData {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //refer to persistant container
    
    func addNewWord(firstWord: String, secondWord : String) -> Bool{
         //create the context
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Words", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(firstWord, forKey: "origin")
        newUser.setValue(secondWord, forKey: "translation")
        do {
           try context.save()
            print("Saved!")
            return true
          } catch {
           print("Failed saving")
        }
        return false
    }
    
    func getWordPair() -> Array<String> {
        return ["", ""]
    }
    
    func updateWordPair() -> Bool{
        return true
    }
    
    func deleteWordPair() -> Bool{
        return true
    }
    
    
}
