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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //below gets the users details to be presented on the setting screen
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //refer to persistant container
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                //SET ALL INITIAL VALUES FOR DISPLAYING
                let language = (data.value(forKey: "language") as! String)
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
        } catch {
            print("Failed")
        }
        
        // Do any additional setup after loading the view.
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

            
            self.addWord() //call the update function
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
        
    }
        
        
    
    func addWord(){
        if let text = firstText.text, !text.isEmpty, let text2 = secondText.text, !text2.isEmpty{
            //are you sure alert here
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //refer to persistant container
            let context = appDelegate.persistentContainer.viewContext
            //create the context
            let entity = NSEntityDescription.entity(forEntityName: "Words", in: context)
            let newWord = NSManagedObject(entity: entity!, insertInto: context)
            newWord.setValue(firstText.text, forKey: "origin")
            newWord.setValue(secondText.text, forKey: "translation")
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
            
        }    }
}




//so the return button works on text fields
extension AddViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
