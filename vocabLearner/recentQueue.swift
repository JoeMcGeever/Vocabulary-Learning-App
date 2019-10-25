//
//  recentQueue.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 23/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import Foundation

struct word {
    var origin: String
    var translation : String
}



class recentlyAdded{
    static let sharedInstance = recentlyAdded() //singleton class
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
        return item
    }
    
}