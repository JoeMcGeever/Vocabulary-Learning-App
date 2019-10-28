//
//  ResultsViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 25/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var correctAnswers: Int = 0
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        scoreLabel.text = "\(correctAnswers)"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
