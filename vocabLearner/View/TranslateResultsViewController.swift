//
//  TranslateResultsViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 04/11/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit

class TranslateResultsViewController: UIViewController {

    var correctAnswers: Int = 0
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        scoreLabel.text = "\(correctAnswers)"
    }
    



}
