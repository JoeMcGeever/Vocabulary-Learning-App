//
//  QuestionData.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 25/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import Foundation

//holds the structure for the question object
//the reasoning for this structure is used in the multiple choice game

struct Question { //a question holds:
    var text : String // the actual question
    var answers : [Answer] // and an array of answer objects
}

struct Answer { //an answer object holds:
    var text : String // the text (answer)
    var correct : Bool // and whether it is correct or not
}
