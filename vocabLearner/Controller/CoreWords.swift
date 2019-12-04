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
    
    func addNewWord(firstWord: String, secondWord : String) -> String{ //adds a new word pair to coreData
        //this function returns a string which is displayed in an alert on the view

        if(getWordPair(searchWord: firstWord)[0] != "" || getWordPair(searchWord: secondWord)[0] != ""){ //if the word already exists
            return "Word already exists" //return this error
        }

         //create the context
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Words", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        //set the values to be saved
        newUser.setValue(firstWord, forKey: "origin")
        newUser.setValue(secondWord, forKey: "translation")
        do {
           try context.save() //save to core data
            //update recently added class:
            RecentlyAdded.sharedInstance.enqueue(origin: firstWord, translation: secondWord)
            return "Added!" // return added!
          } catch {
           return "Failed saving" //return fail if it fails for some reason
        }
    }
    
    func getWordPair(searchWord : String) -> Array<String> {
        //GETS WORD PAIR - RETURNS 2 EMPTY STRINGS IF NOT FOUND
        let context = appDelegate.persistentContainer.viewContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Words") //view in the table called 'Words'
        //if the word is present as either an origin or translation
        request.predicate = NSPredicate(format: "origin = %@ OR translation = %@", searchWord, searchWord) //search in core data using an OR statement
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let origin = (data.value(forKey: "origin") as! String)
                let translation = (data.value(forKey: "translation") as! String)
                return [origin, translation] //return within an array
          }
        } catch {
            print("Failed")
        }
        return ["", ""]// otherwise, return an array of 2 empty strings
    }
    
    
    func updateWordPair(searchWord: String, firstWord: String, secondWord: String) -> Bool{
        //this function updates a word pair
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   //refer to persistant container
                let context = appDelegate.persistentContainer.viewContext
                   //create the context
                
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Words")
                fetchRequest.predicate = NSPredicate(format: "origin = %@ OR translation = %@", searchWord, searchWord) //search in core data for the word pair
                do {
                    let test = try context.fetch(fetchRequest)
                    if(test.isEmpty){
                        return false
                    }
                    let itemUpdate = test[0] as! NSManagedObject
                    
                    //update the values:
                    itemUpdate.setValue(firstWord, forKey: "origin")
                    
                    itemUpdate.setValue(secondWord, forKey: "translation")
                    do {
                        try context.save() //save into core data
                        return true
                    }
                    catch {
                        throw(error)
                    }
                }
                catch {
                    print("error")
                    return false
                }
     
        
        
    }
    
    func deleteWordPair(searchWord: String) -> Bool{
        //refer to persistant container
        let context = appDelegate.persistentContainer.viewContext
        //create the context
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Words")
        fetchRequest.predicate = NSPredicate(format: "origin = %@ OR translation = %@", searchWord, searchWord)//search in core data for the word pair
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            context.delete(obj as! NSManagedObject) //delete the object
        }
        do {
            try context.save() // save to core data
        } catch {
            return false
        }
        return true
    }
    
    func getTenPairs() -> Array<Question>?{ //this fucntion uses the model to organise the data into 10 question and answers (1 : 4 ratio)
        //an advantage of core data is the ability to get all from it with little impact to performance due to a mechanism called "faulting"
        //get all into array
        //shuffle array
        //take first 10
        var questions =  [Question]()
        
        let context = appDelegate.persistentContainer.viewContext
        
       
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Words")
        //fetchRequest.returnsObjectsAsFaults = false //THIS DISABLES FAULTING
        
        var objects = try! context.fetch(fetchRequest) as! [NSManagedObject] //fetch all objects from core data
        
        var question = ""
        var answer : Answer
        var wrongAnswer1: Answer
        var wrongAnswer2: Answer
        var wrongAnswer3: Answer
        
        //print(objects[0])
        //print(objects[0].value(forKey: "origin") ?? "No value")
        
        let numberOfPairs = objects.count
        
        if(numberOfPairs < 10) {
            return nil //an empty array is returns if there isnt 10 words saved (which will display an alert (error) in the view)
        }
        
        objects = objects.shuffled() //re-orders array by shuffling
        var random1 : Int
        var random2: Int
        var random3: Int
        
        for i in 0...9 { //loop 10 times
            //takes from a randomly shuffled array; the first 10 items
            random1 = i
            random2 = i
            random3 = i
            while(random1 == i || random2 == i || random3 == i || random1 == random2 || random1 == random3 || random2 == random3){ //randomly generates until all items are random and different
                random1 = Int.random(in: 0...numberOfPairs - 1)
                random2 = Int.random(in: 0...numberOfPairs - 1)
                random3 = Int.random(in: 0...numberOfPairs - 1)
            }
            //sets the wrongAnswer variables to be one of the incorrect answers (taken from core data)
            //sets the correct variable of each to be "false" so the games know that these are incorrect answers
             wrongAnswer1 = Answer(text: objects[random1].value(forKey: "translation") as! String, correct : false)
             wrongAnswer2 = Answer(text: objects[random2].value(forKey: "translation") as! String, correct : false)
             wrongAnswer3 = Answer(text: objects[random3].value(forKey: "translation") as! String, correct : false)
            
            
            question = objects[i].value(forKey: "origin") as! String //sets the quetion
            answer = Answer(text: objects[i].value(forKey: "translation") as! String, correct : true) //sets the correct answer (the translation of the question)
            
            questions.append(Question(text: question, answers: [answer, wrongAnswer1, wrongAnswer2, wrongAnswer3])) //append the question and its 4 answers
            

        }

        
        return questions //return the 10 questios
    }
    
    
}
