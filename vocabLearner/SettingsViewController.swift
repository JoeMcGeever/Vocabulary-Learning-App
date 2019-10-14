//
//  SettingsViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 07/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    var currentUsername : String = "" //variables used to chaneg the users name
    var newUsername : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self //this is to allow the return key to work
        
        //below gets the users details to be presented on the setting screen
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //refer to persistant container
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
               print(data.value(forKey: "name") as! String)
                currentUsername = (data.value(forKey: "name") as! String)
                nameTextField.text = currentUsername
          }
        } catch {
            print("Failed")
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cofirmButton(_ sender: Any) {
        
        //show a "are you sure" message:
        
        let refreshAlert = UIAlertController(title: "Are you sure?", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            self.newUsername = self.nameTextField.text ?? self.currentUsername //fill the new name in newUsername -- if nothing, keep as is
            self.updateData() //call the update function
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)    }
    
    
    
    
    func updateData(){
        //This function updates the data for name
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
           //refer to persistant container
        let context = appDelegate.persistentContainer.viewContext
           //create the context
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        print("new name: \(newUsername)")
        print("current name: \(currentUsername)")
        fetchRequest.predicate = NSPredicate(format: "name = %@", currentUsername)
        do {
            let test = try context.fetch(fetchRequest)
            print(test)
            let itemUpdate = test[0] as! NSManagedObject
            itemUpdate.setValue(newUsername, forKey: "name")
            currentUsername = newUsername //update the current username value
            do {
                try context.save()
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
    }

}

extension SettingsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
