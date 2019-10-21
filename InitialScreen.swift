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

class InitialScreenViewController :UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
 
    
    
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    let language = ["Inapplicable","German", "Spanish", "French"] //set up array for picker view
    var selectedLangauge : String = "Inapplicable"
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextBox.delegate = self
        }
    
    //setting up for picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //how many rows we have --> only need 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return language[row] //displays each component in different rows in our picker view
    }
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return language.count
     }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLangauge = language[row] //what happend when user selects row
    }

    
    
    @IBAction func confirm(_ sender: Any) {
        //print(selectedLangauge)
       
        
        if let text = nameTextBox.text, !text.isEmpty {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //refer to persistant container
            let context = appDelegate.persistentContainer.viewContext
            //create the context
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(nameTextBox.text, forKey: "name")
            newUser.setValue(selectedLangauge, forKey: "language")
            do {
               try context.save()
                print("Saved!")
              } catch {
               print("Failed saving")
            }
            
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Hold on!", message: "Please fill in all the details", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok!", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        }
        
        //and validate to see if all data is entered
    }
    
}

extension InitialScreenViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }

