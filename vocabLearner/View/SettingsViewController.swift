//
//  SettingsViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 07/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var languageLabel: UILabel!

    @IBOutlet weak var pickerView: UIPickerView!
    
    
    let languageArray = ["Inapplicable","German", "Spanish"] //set up array for picker view
    
    var currentUsername : String = "" //variables used to chaneg the users name
    var newUsername : String = ""
    var language : String = ""
    var selectedLanguage : String = "Inapplicable" //sets a standard if the picker should fail
    let userCoreData = UsersCoreData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self //this is to allow the return key to work
        
        //below gets the users details to be presented on the setting screen
        let userDetails = userCoreData.getUserDetails()
        currentUsername = userDetails[0]
        nameTextField.text = userDetails[0]
        languageLabel.text = userDetails[1]

    }
    
    
    //setting up for picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //how many rows we have --> only need 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageArray[row] //displays each component in different rows in our picker view
    }
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageArray.count
     }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLanguage = languageArray[row] //what happend when user selects row
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
    }
    
    @IBAction func cofirmButton(_ sender: Any) { //to update core data with your updated data
        
        //show a "are you sure" message:
            let refreshAlert = UIAlertController(title: "Are you sure?", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in //if user selects confirm
            
            self.newUsername = self.nameTextField.text ?? self.currentUsername //fill the new name in newUsername -- if nothing, keep as is
            
            if(self.userCoreData.updateData(oldName : self.currentUsername ,newName: self.newUsername, lang: self.selectedLanguage)) //updates the users details through the controller
            {
                print("Success")
            }
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          //otherwise the user selects cancel
          }))

        present(refreshAlert, animated: true, completion: nil) //display the alert created above
    }
    
    

}

//so the return button works on text fields
extension SettingsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
