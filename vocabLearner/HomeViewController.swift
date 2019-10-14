//
//  ViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 04/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit
import CoreData
//https://www.iosapptemplates.com/blog/ios-development/data-persistence-ios-swift
// ^ data persistance --> have a look at Plists
class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         if(firstTime()){
            performSegue(withIdentifier: "initialStartUp", sender: nil)
            viewDidLoad()
        }
        //FETCH NAME FROM CORE DATA
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //refer to persistant container
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
               print(data.value(forKey: "name") as! String)
               nameLabel.text = (data.value(forKey: "name") as! String)
          }
        } catch {
            print("Failed")
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
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

