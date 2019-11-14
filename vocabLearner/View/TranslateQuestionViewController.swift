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
    var questions : Array<Question> = []
    
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var translation: UITextField!
    
    @IBOutlet weak var confirm: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        nextQuestion()
        
    }
    
    @IBOutlet weak var response: UILabel!
    
    
    var questionIndex = 0
    var correctAnswers = 0
    var currentAnswer = ""
    
    @IBOutlet var progressBar: UIProgressView!
    
    struct Response : Codable{ //thsi is the structure of the response sent by the API wordsAPI
        let word : String
        let typeOf : Array <String>
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translation.delegate = self //so it can return from keyboard
        questions = wordsCoreData.getTenPairs() ?? [Question(text: "", answers: [Answer(text: "", correct: false)])]
        if(questions[0].text == ""){
            let alert = UIAlertController(title: "Cannot play", message: "You need at least 10 word pairs to play", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok!", style: .default) { (action) in self.performSegue(withIdentifier: "ResultsSegue", sender : action)}
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            
        }else {

            updateUI()
        }
        //get the 10 pairs of words        //get 10 questions + 4 answers, one correct
        
    }
    
    @IBAction func confirm(_ sender: Any) {
        //check answer is correct here - similar to singleAnswerButton.. func
        var text = translation.text
        if text?.isEmpty ?? true{
            response.text = "Enter something first"
            return
        }
        
        let headers = [
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
            "x-rapidapi-key": "63caad11ccmsh4d5b696252bbe68p178817jsnb18aaaa6885c"
        ]
        
        //currentAnswer = no space + lowercase
        currentAnswer = (currentAnswer.filter { !$0.isNewline && !$0.isWhitespace }).lowercased()
        text = (text!.filter { !$0.isNewline && !$0.isWhitespace }).lowercased()
        print(currentAnswer)
        print(text!)
        
        let urlString = "https://wordsapiv1.p.rapidapi.com/words/\(currentAnswer)/typeOf"
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                //let httpResponse = response as? HTTPURLResponse
                //print(httpResponse!)
                //print(data as Any)
                let responseData = String(data: data!, encoding: String.Encoding.utf8)
                print(responseData as Any) //maybe can try string manip here
                
                
                do{
                    let jsonDecoder = JSONDecoder()
                    let dataObject = try jsonDecoder.decode(Response.self, from: data!)
                    print("JSON decoded here:")
                    print(dataObject)
                    let synonyms = dataObject.typeOf
                    print(synonyms) //here is the array of synonyms ---> how to use then outise this dataTask function :shrug:
                    
                }
                catch {
                    print("Failed decoding")
                }
                

                
            }
        })
        
        
        dataTask.resume()
        
        ///api call returns synonyms for the answer -> if the user enters the correct answer or one of its synonyms, = correct
        //array should be all lower case no space
        
        
        
        
        
         if (currentAnswer == text){
            correctAnswers += 1
            response.text = "Correct!"
            confirm.isUserInteractionEnabled = false
            
            nextButton.isUserInteractionEnabled = true
            nextButton.setTitleColor(.none, for: .normal)
        } else {
            response.text = "Incorrect. Above is the correct answer"
            translation.text = currentAnswer
            confirm.isUserInteractionEnabled = false
            
            nextButton.isUserInteractionEnabled = true
            nextButton.setTitleColor(.none, for: .normal)
            
        }
        
    }
    
    func updateUI() {
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
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "TranslateResultsSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TranslateResultsSegue" {
            let resultsViewController = segue.destination as! TranslateResultsViewController
            resultsViewController.correctAnswers = correctAnswers
        }
    }
}

extension TranslateQuestionViewController : UITextFieldDelegate {

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
