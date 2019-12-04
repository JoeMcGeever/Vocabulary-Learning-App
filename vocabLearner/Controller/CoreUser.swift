//
//  CoreUser.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 21/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class UsersCoreData {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //refer to persistant container
    
    
    func addNewUser(name : String, lang : String) -> Bool{ //saves all necessary data for a user
         //create the context
        if(name=="" || lang=="") {
            return false
        }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context) //set the entity that we wish to manipulate
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(name, forKey: "name")
        newUser.setValue(lang, forKey: "language")
        //set the values in core data for the key
        do {
           try context.save()
            print("Saved!")
            return true //returns true if success
          } catch {
           print("Failed saving")
        }
        return false
        
    }
    
    func getUserDetails() -> Array<String> { //returns the users details
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                //print(data.value(forKey: "name") as! String)
                //print(data.value(forKey: "name") as! String)
                let name = (data.value(forKey: "name") as! String)
                let lang = (data.value(forKey: "language") as! String)
                return [name, lang] //returns as an array
          }
        } catch {
            print("Failed")
        }
        return ["", ""] //otherwise, return an array of 2 empty strings
    }
    
    func updateData(oldName : String, newName : String, lang : String) -> Bool {
        //This function updates the data for name
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
               //refer to persistant container
            let context = appDelegate.persistentContainer.viewContext
               //create the context
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "name = %@", oldName) //search the core data using the oldName of the user (the one that is currently saved)
            do {
                let test = try context.fetch(fetchRequest)
                
                if(!test.isEmpty){ // if the data is already set (so just updating)
                    let itemUpdate = test[0] as! NSManagedObject
                    itemUpdate.setValue(newName, forKey: "name")
                    itemUpdate.setValue(lang, forKey: "language")
                    //then set the new values
                    
                } else {
                    print(addNewUser(name: newName, lang: lang)) //otherwise, simply use the add new user function
                }
                
                do {
                    try context.save() //save the updates into core data
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

    
}
