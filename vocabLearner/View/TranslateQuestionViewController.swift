//
//  TranslateQuestionViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 04/11/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit

class TranslateQuestionViewController: UIViewController {
    
    let wordsCoreData = WordsCoreData()
    var questions : Array<Question> = [] //holds an array of quesitons
    
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var translation: UITextField!
    
    @IBOutlet weak var confirm: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        nextQuestion() //calls next question
        
    }
    
    @IBOutlet weak var response: UILabel!
    
    
    var questionIndex = 0
    var correctAnswers = 0
    var currentAnswer = ""
    
    @IBOutlet var progressBar: UIProgressView!
    
    struct Response : Codable{ //this is the structure of the response sent by the API wordsAPI
        let word : String
        let typeOf : Array <String>
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translation.delegate = self //so it can return from keyboard
        questions = wordsCoreData.getTenPairs() ?? [Question(text: "", answers: [Answer(text: "", correct: false)])] // populates the question array
        if(questions[0].text == ""){ //users need 10 translations to play
            let alert = UIAlertController(title: "Cannot play", message: "You need at least 10 word pairs to play", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok!", style: .default) { (action) in self.performSegue(withIdentifier: "TranslateResultsSegue", sender : action)}
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }else {
            updateUI() //if user has at least 10 words, ustart the game
        }
        //get the 10 pairs of words
        //get 10 questions + 4 answers, one correct
        
    }
    
    
    
    
    
    
    
    func getSynonym(word:String, completionHandler: @escaping (Array<String>) -> ()) {
        //an API request to return synonyms of a selection of questions
        
        let headers = [
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
            "x-rapidapi-key": "63caad11ccmsh4d5b696252bbe68p178817jsnb18aaaa6885c"
        ]
        let urlString = "https://wordsapiv1.p.rapidapi.com/words/\(word)/typeOf" //inject into the url, the word I wish to get the synonyms of
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET" //GET request
        request.allHTTPHeaderFields = headers //include the headers (including my API key)
        
        let session = URLSession.shared
        
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in //async func here URLSession  { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                //let responseData = String(data: data!, encoding: String.Encoding.utf8)
                //print(responseData as Any)
    
                do{
                    let jsonDecoder = JSONDecoder()
                    let dataObject = try jsonDecoder.decode(Response.self, from: data!)
                    //print("JSON decoded here:")
                    //print(dataObject)
                    let synonyms = dataObject.typeOf
                    //print(synonyms) //here is the array of synonyms ---> how to use then outise this dataTask function :shrug:
                    completionHandler(synonyms) //return in the completion handler --> callback
                }
                catch {
                    print("Failed decoding")
                    completionHandler([])
                    
                }
            }
            }).resume()
    
    }
    
    
    
    
    
    

    
    
    
    
    @IBAction func confirm(_ sender: Any) {
        //check answer is correct here - similar to singleAnswerButton.. func
        var text = translation.text
        if text?.isEmpty ?? true{
            response.text = "Enter something first"
            return
        }
        
        //currentAnswer = no space + lowercase
        currentAnswer = (currentAnswer.filter { !$0.isNewline && !$0.isWhitespace }).lowercased()
        text = (text!.filter { !$0.isNewline && !$0.isWhitespace }).lowercased()
        print(currentAnswer)
        print(text!)
        
        getSynonym(word: currentAnswer, completionHandler: { (synonyms) in //calls the async function whcih returns the array
            
            
            DispatchQueue.main.async { //pulls to the main thread, so the function no longer runs asynchronously
                //print(synonyms)
                
                
                var validatedSynonyms : Array<String> = []
                for i in synonyms { //format the same as if it was a given answer
                    
                    validatedSynonyms.append((i.filter { !$0.isNewline && !$0.isWhitespace }).lowercased()) //formulate the synonym words to follow the same standard foprmat
                    
                }
                print(validatedSynonyms)
                
                if (self.currentAnswer == text || validatedSynonyms.contains(text!) ){ //if the user enters the correwct translation, or the translation is a synonym
                    self.correctAnswers += 1
                    self.response.text = "Correct!"
                    self.confirm.isUserInteractionEnabled = false // cannot confirm again
                    
                    self.nextButton.isUserInteractionEnabled = true //but can continue to next question
                    self.nextButton.setTitleColor(.none, for: .normal)
                } else {
                    self.response.text = "Incorrect. Above is the correct answer"
                    self.translation.text = self.currentAnswer //display the correct answer
                    self.confirm.isUserInteractionEnabled = false
                    
                    self.nextButton.isUserInteractionEnabled = true
                    self.nextButton.setTitleColor(.none, for: .normal)
                    
                }
            }
        })
        
    }
    
    func updateUI() {
        //update the UI
        
        translation.text = ""
        response.text = ""
        confirm.isUserInteractionEnabled = true
        nextButton.isUserInteractionEnabled = false
        nextButton.setTitleColor(.lightGray, for: .normal)
                
        navigationItem.title = "Question \(questionIndex+1)"
        let currentQuestion = questions[questionIndex]
        currentAnswer = currentQuestion.text //as the first answer is always the correct one (see the coreWords file. Fucntion: getTenPairs
        

        let totalProgress = Float(questionIndex+1) / Float(questions.count)
        
        origin.text = currentQuestion.answers[0].text
        progressBar.setProgress(totalProgress, animated: true)

        
    }
    
    
    func nextQuestion() {
        questionIndex += 1
        if questionIndex < questions.count { //if there are more questions, repeat the process again
            updateUI()
        } else {
            performSegue(withIdentifier: "TranslateResultsSegue", sender: nil) //otherwise, programatically segue
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //sends the score to the results view
        if segue.identifier == "TranslateResultsSegue" {
            let resultsViewController = segue.destination as! TranslateResultsViewController
            resultsViewController.correctAnswers = correctAnswers
        }
    }
}

extension TranslateQuestionViewController : UITextFieldDelegate { //so keyboard is dismissed upon "return" being pressed

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
