//
//  QuestionData.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 25/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import Foundation

struct Question {
    var text : String
    var answers : [Answer]
}

struct Answer {
    var text : String
    var correct : Bool
}
