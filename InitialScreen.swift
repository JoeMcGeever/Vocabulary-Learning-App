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
        print(nameTextBox.text!) //WORKS -> NEED TO SAVE TO DATABASE
       
        if let text = nameTextBox.text, !text.isEmpty {
            //var name : [NSManagedObject] = text SAVE TO DB HERE
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Hold on!", message: "Please fill in all the details", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok!", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        }
        
        
        
        
        //and validate to see if all data is entered
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

