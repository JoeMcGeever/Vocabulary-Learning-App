//
//  ViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 04/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var language = "Inapplicable"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
         if(firstTime()){
            //show initial set up if
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
               //print(data.value(forKey: "name") as! String)
               nameLabel.text = (data.value(forKey: "name") as! String)
               language = (data.value(forKey: "language") as! String)
                
            }
        } catch {
            print("Failed")
        }
        
        //sets the background image using the programatic extension
        //added for view
        self.view.addBackground(language: language)
        
    }

    //so updates on other views will change this one accordingly
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
        self.view.addBackground(language: language)
    }
    
    func firstTime()->Bool{
        let defaults = UserDefaults.standard

        if defaults.string(forKey: "firstTime") != nil{
            //print("App already launched : \(firstTime)")
            return false
        }else{
            defaults.set(true, forKey: "firstTime")
            //print("App launched first time")
            return true
        }
    }
    
}



extension UIView {
    func addBackground(language : String) {
    // screen width and height:
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height

    let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    
        
        //switch case to determine which image to use
        switch language {
        case "German":
            imageViewBackground.image = UIImage(named: "German.png")
        case "Spanish":
            imageViewBackground.image = UIImage(named: "Spanish.png")
        default:
            imageViewBackground.backgroundColor = .red
        }
        
        
    // you can change the content mode:
    imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill

    self.addSubview(imageViewBackground)
    self.sendSubviewToBack(imageViewBackground)
}}
