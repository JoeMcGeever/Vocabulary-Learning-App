//
//  GamesViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 07/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController {

    let wordsCoreData = WordsCoreData()
    @IBAction func unwindToGamePage(segue: UIStoryboardSegue) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(wordsCoreData.getTenPairs()[0])
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
