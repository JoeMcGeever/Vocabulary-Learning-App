//
//  ViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 04/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        performSegue(withIdentifier: "initialStartUp", sender: nil)
       
        
        // if(firstTime()){
       //     performSegue(withIdentifier: "initialStartUp", sender: nil)
        //}
    }

    
    
    
    func firstTime()->Bool{
        let defaults = UserDefaults.standard

        if let firstTime = defaults.string(forKey: "firstTime"){
            print("App already launched : \(firstTime)")
            return false
        }else{
            defaults.set(true, forKey: "firstTime")
            print("App launched first time")
            return true
        }
    }
    
}

