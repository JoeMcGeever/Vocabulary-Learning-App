//
//  ResultsViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 25/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var correctAnswers: Int = 0 //this variable gets updated through a programatic segue
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        scoreLabel.text = "\(correctAnswers)" //display the score
    }
    



}
