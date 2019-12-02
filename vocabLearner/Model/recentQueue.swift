//
//  recentQueue.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 23/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import Foundation

//holds a queue for recvently added words
//so users can view and delete accordingly

struct word { //a word object contains its origin and its translation
    var origin: String
    var translation : String
}



class RecentlyAdded{
    static let sharedInstance = RecentlyAdded() //singleton class
    //so only one is manipulated
    
    var item: Array<word> = []
    
    func enqueue(origin : String, translation : String){
        if(item.count >= 20) {
            item.remove(at: 0) //dequeue the first item
        }
        let tempWord = word(origin: origin, translation: translation)
        item.append(tempWord)
        print(item)
    }
    
    
    func getArray() -> Array<word> {
        return item //returns the array of words (structure above(
    }
    
    func removeItem(originToRemove: String){ //removes item from array when deleted from recently added
        for i in 0...item.count {
            if(item[i].origin == originToRemove) {
                item.remove(at: i)
                break
            }
        }
        
    }
    
}
