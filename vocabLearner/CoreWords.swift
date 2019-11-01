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
        //MAY NEED TO ADD A COUNT WHICH SAVES TO USER PERSISTENCE
        //ALONG WITH SAVE ALL WORDS WITH AN ID THAT INCREMENTS (SO EQUALS THE COUNT IN PERSISTANCE)
        //THIS IS SO WE CAN RANDOMLY GENERATE 10 NUMBERS UP TO THE COUNT
        //FOR THE GAME

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
    
    func getTenPairs() -> Array<Question>{
        
        //this will be easier with a layer
        //an advantage of core data is the ability to get all from it with little impact to performance due to a mechanism called "faulting"
        //get all into array
        //shuffle array
        //take first 10
        
        var questions =  [Question]()
        
        let context = appDelegate.persistentContainer.viewContext
        
       
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Words")
        //fetchRequest.returnsObjectsAsFaults = false //THIS DISABLES FAULTING
        
        var objects = try! context.fetch(fetchRequest) as! [NSManagedObject]
        
        var question = ""
        var answer : Answer
        var wrongAnswer1: Answer
        var wrongAnswer2: Answer
        var wrongAnswer3: Answer
        
        //print(objects[0])
        //print(objects[0].value(forKey: "origin") ?? "No value")
        
        let numberOfPairs = objects.count
        
        if(numberOfPairs < 10) {
            return questions //NOTE AN EMPTY ARRAY WILL BE RETURNED
            //IF NOT AT LEAST 10 ENTRIES
        }
        
        objects = objects.shuffled() //re-orders array
        var random1 : Int
        var random2: Int
        var random3: Int
        
        for i in 0...9 {
            random1 = i
            random2 = i
            random3 = i
            while(random1 == i || random2 == i || random3 == i){
                random1 = Int.random(in: 0...numberOfPairs - 1)
                random2 = Int.random(in: 0...numberOfPairs - 1)
                random3 = Int.random(in: 0...numberOfPairs - 1)
            }
             wrongAnswer1 = Answer(text: objects[random1].value(forKey: "translation") as! String, correct : false)
             wrongAnswer2 = Answer(text: objects[random2].value(forKey: "translation") as! String, correct : false)
             wrongAnswer3 = Answer(text: objects[random3].value(forKey: "translation") as! String, correct : false)
            
            
            question = objects[i].value(forKey: "origin") as! String
            answer = Answer(text: objects[i].value(forKey: "translation") as! String, correct : true)
            
            questions.append(Question(text: question, answers: [answer, wrongAnswer1, wrongAnswer2, wrongAnswer3]))
            
            //SHOULD RANDOMISE POSITION IN BANDICOOT
            //SO JUST GUESS GAME CAN SIMPLY BE FIRST ANSWER ALWAYS TRUE
            
        }
        //successfully gets 10 rando question and 4 answers, first one is correct, rest are not :D
        
        return questions
    }
    
    
}
