//
//  EditViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 07/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    

    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var translationLabel: UILabel!
    
    @IBOutlet weak var searchWord: UITextField!
    @IBOutlet weak var origin: UITextField!
    @IBOutlet weak var translation: UITextField!
    
    var originWord : String = ""
    var translationWord: String = ""
    var text = ""
    var searched = false
    
    let wordsCoreData = WordsCoreData()
    let userCoreData = UsersCoreData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searched = false
        
        origin.delegate = self
        translation.delegate = self
        searchWord.delegate = self
        
        searchWord.text = ""
        origin.text = ""
        translation.text = ""
        originWord = ""
        translationWord = ""
        
        
        //sets the interaction to false so users cannot manipulate
        origin.isUserInteractionEnabled = false
        translation.isUserInteractionEnabled = false
        origin.backgroundColor = .lightGray
        translation.backgroundColor = .lightGray
        
        
        let userDetails = userCoreData.getUserDetails()
        let language = userDetails[1] //this holds the users language
        //sets the labels above the text boxes
        //only needed if user is learning a language
        if(language != "Inapplicable"){
            originLabel.text = "English"
            translationLabel.text = language
        } else {
            originLabel.text = ""
            translationLabel.text = ""
        }
    }
    
    
    //so when return tot he page, it reloads
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
    }

    @IBAction func searchButton(_ sender: Any) {
        
        text = searchWord.text ?? ""
        if  text != ""{
            searched = true
            let searchResult = wordsCoreData.getWordPair(searchWord: text)
            
            //populate the 2 text fields with the data
            if(searchResult[0] != ""){ //if there is a value
                
                //populate the text fields
                origin.text = searchResult[0]
                translation.text = searchResult[1]
                
                //allow interaction
                origin.isUserInteractionEnabled = true
                translation.isUserInteractionEnabled = true
                origin.backgroundColor = .none
                translation.backgroundColor = .none
            } else {
                searched = false
                
                origin.text = ""
                translation.text = ""
                //sets the interaction to false so users cannot manipulate
                origin.isUserInteractionEnabled = false
                translation.isUserInteractionEnabled = false
                origin.backgroundColor = .lightGray
                translation.backgroundColor = .lightGray
                
            }
            
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "Please search for something", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok!", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    
    @IBAction func deleteButton(_ sender: Any) {
        //ONLY ALLOW IF SEARCH IS COMPLETED
        if(searched == true){
        let refreshAlert = UIAlertController(title: "Are you sure?", message: "This word will be deleted.", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")

            //do delete stuff here
            if(self.wordsCoreData.deleteWordPair(searchWord: self.searchWord.text!)){
                print("Delete was successful")
            }
            
            
            self.viewDidLoad() // refresh view
            
          }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))
        present(refreshAlert, animated: true, completion: nil)
        } else {
            print("nothing was searched")
        }
    
        
    }
    
    
    
    @IBAction func confirmButton(_ sender: Any) {
        //ONLY ALLOW IF SEARCH IS COMPLETED
        originWord = origin.text ?? ""
        translationWord = translation.text ?? ""
        if (originWord == "" || translationWord == "") {
            //error message
        }
        else if(searched == true) {
            //do update data stuff here
            print(wordsCoreData.updateWordPair(searchWord: text, firstWord: originWord, secondWord: translationWord))
        }
        viewDidLoad()
    }

}

//so the return button works on text fields
extension EditViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
