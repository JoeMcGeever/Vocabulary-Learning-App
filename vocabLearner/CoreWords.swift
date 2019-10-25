//
//  CoreWords.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 21/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//


import CoreData
import UIKit

class WordsCoreData {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //refer to persistant container
    
    func addNewWord(firstWord: String, secondWord : String) -> String{
        //search to see if word already exists

        if(getWordPair(searchWord: firstWord)[0] != "" || getWordPair(searchWord: secondWord)[0] != ""){
            //print("Word already exists")
            return "Word already exists"
        }

         //create the context
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Words", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(firstWord, forKey: "origin")
        newUser.setValue(secondWord, forKey: "translation")
        do {
           try context.save()
            //update recently added class:
            recentlyAdded.sharedInstance.enqueue(origin: firstWord, translation: secondWord)
            return "Added!"
          } catch {
           return "Failed saving"
        }
    }
    
    func getWordPair(searchWord : String) -> Array<String> {
        //GETS WORD PAIR - RETURNS 2 EMPTY STRINGS IF NOT FOUND
        let context = appDelegate.persistentContainer.viewContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Words")
        //if the word is present as either an origin or translation
        request.predicate = NSPredicate(format: "origin = %@ OR translation = %@", searchWord, searchWord)
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let origin = (data.value(forKey: "origin") as! String)
                let translation = (data.value(forKey: "translation") as! String)
                return [origin, translation]
          }
        } catch {
            print("Failed")
        }
        return ["", ""]
    }
    
    
    func updateWordPair(searchWord: String, firstWord: String, secondWord: String) -> Bool{
        //this function updates a word pair
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   //refer to persistant container
                let context = appDelegate.persistentContainer.viewContext
                   //create the context
                
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Words")
                fetchRequest.predicate = NSPredicate(format: "origin = %@ OR translation = %@", searchWord, searchWord)
                do {
                    let test = try context.fetch(fetchRequest)
                    print(test)
                    let itemUpdate = test[0] as! NSManagedObject
                    
                    itemUpdate.setValue(firstWord, forKey: "origin")
                    
                    itemUpdate.setValue(secondWord, forKey: "translation")
                    do {
                        try context.save()
                        return true
                    }
                    catch {
                        throw(error)
                    }
                }
                catch {
                    print("error")
                }
        return false
        
        
        
    }
    
    func deleteWordPair(searchWord: String) -> Bool{
        
          //refer to persistant container
        let context = appDelegate.persistentContainer.viewContext
        //create the context
                    
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Words")
        fetchRequest.predicate = NSPredicate(format: "origin = %@ OR translation = %@", searchWord, searchWord)
        
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            context.delete(obj as! NSManagedObject)
        }
        
        do {
            try context.save() // <- remember to put this :)
        } catch {
            return false
        }
        return true
    }
    
    
}
