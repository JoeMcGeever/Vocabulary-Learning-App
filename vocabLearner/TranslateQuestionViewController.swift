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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if(currentAnswer == translation.text){
            correctAnswers += 1
            response.text = "Correct!"
        } else {
            response.text = "Incorrect, here is the correct answer:"
            translation.text = currentAnswer
        }
        nextButton.isUserInteractionEnabled = true
        nextButton.setTitleColor(.none, for: .normal)
        
    }
    
    func updateUI() {
        translation.text = ""
        nextButton.isUserInteractionEnabled = false
        nextButton.setTitleColor(.lightGray, for: .normal)
        
        
        navigationItem.title = "Question \(questionIndex+1)"
        let currentQuestion = questions[questionIndex]
        currentAnswer = currentQuestion.answers[0].text //as the first answer is always the correct one (see the coreWords file. Fucntion: getTenPairs
        let totalProgress = Float(questionIndex+1) / Float(questions.count)
        
        print("ALLES GUT HIER")
        origin.text = currentQuestion.text
        progressBar.setProgress(totalProgress, animated: true)
        print("ALLES GUT HIER")
        
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
        if segue.identifier == "ResultsSegue" {
            let resultsViewController = segue.destination as! ResultsViewController
            resultsViewController.correctAnswers = correctAnswers
        }
    }
}
