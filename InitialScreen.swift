//
//  InitialScreen.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 09/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class InitialScreenViewController :UIViewController{
    
    @IBOutlet weak var nameTextBox: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextBox.delegate = self
            }
    
    
    
    
    @IBAction func confirm(_ sender: Any) {
        //and validate to see if all data is entereds
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //refer to persistant container
        let context = appDelegate.persistentContainer.viewContext
        //create the context
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(nameTextBox.text, forKey: "name")
        do {
           try context.save()
            print("Saved!")
          } catch {
           print("Failed saving")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(nameTextBox: UITextField) -> Bool {   //delegate method
      nameTextBox.resignFirstResponder()
      return true
    }
}

extension InitialScreenViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }

