//
//  InitialScreen.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 09/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import Foundation
import UIKit

class InitialScreenViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func confirm(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
