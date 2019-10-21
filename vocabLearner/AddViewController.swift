//
//  AddViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 07/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstText: UITextField!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondText: UITextField!
    let wordsCoreData = WordsCoreData()
    let userCoreData = UsersCoreData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstText.delegate = self
        secondText.delegate = self
        //below gets the users language details to be presented on the setting screen
        let userDetails = userCoreData.getUserDetails()
        let language = userDetails[1] //this holds the users language
        //sets the labels above the text boxes
        //only needed if user is learning a language
        if(language != "Inapplicable"){
            firstLabel.text = "English"
            secondLabel.text = language
        } else {
            firstLabel.text = ""
            secondLabel.text = ""
        }
    }

    //so updates on other views will change this one accordingly
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Are you sure?", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")

            self.addWord() //call the addWord function
          }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))
        present(refreshAlert, animated: true, completion: nil)
    }
        
        
    
    func addWord(){
        if let text = firstText.text, !text.isEmpty, let text2 = secondText.text, !text2.isEmpty{
            //call module
            if(wordsCoreData.addNewWord(firstWord: firstText.text!, secondWord: secondText.text!)){
                print("Added!")
            }
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Hold on!", message: "Please fill in all the details", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok!", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil) 
        }
        
    }
}




//so the return button works on text fields
extension AddViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
