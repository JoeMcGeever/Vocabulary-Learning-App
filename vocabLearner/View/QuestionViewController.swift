//
//  QuestionViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 25/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    

    
    let wordsCoreData = WordsCoreData()
    
    var questions : Array<Question> = []
    @IBOutlet weak var singleStackView: UIStackView!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet weak var oneQResult: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBAction func nextQuestionButton(_ sender: Any) {
        nextQuestion()
    }
    @IBOutlet weak var nextQuestionButton: UIButton!
    
    
    var randomNumbers = [0,1,2,3]
    var a = 0
    var b = 1
    var c = 2
    var d = 3
    
    
    var questionIndex = 0
    var correctAnswers = 0
    
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
    
    func updateUI() {
        oneQResult.text = ""
        nextQuestionButton.isUserInteractionEnabled = false
        nextQuestionButton.setTitleColor(.lightGray, for: .normal)
        
        navigationItem.title = "Question \(questionIndex+1)"
        let currentQuestion = questions[questionIndex]
        let currentAnswers = currentQuestion.answers
        let totalProgress = Float(questionIndex+1) / Float(questions.count)
        
        questionLabel.text = currentQuestion.text
        progressBar.setProgress(totalProgress, animated: true)
        
        updateSingleStack(using : currentAnswers)
    }
    
    func updateSingleStack(using answers: [Answer]) {
        
        randomNumbers = randomNumbers.shuffled()
        a = randomNumbers[0]
        b = randomNumbers[1]
        c = randomNumbers[2]
        d = randomNumbers[3]
        
        button1.setTitle(answers[a].text, for: .normal)
        button2.setTitle(answers[b].text, for: .normal)
        button3.setTitle(answers[c].text, for: .normal)
        button4.setTitle(answers[d].text, for: .normal)
        
    }
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        var correctAnsPos = 0
        for i in 0...3{ //gets the position of which answer is correct
            if(questions[questionIndex].answers[i].correct == true) {
                correctAnsPos = i
                break
            }
        }
        switch sender {
        case button1:
            if(questions[questionIndex].answers[a].correct == true) {
                correctAnswers += 1
                oneQResult.text = "Correct!"
            } else {
                oneQResult.text = "Incorrect. The correct answer is: \(questions[questionIndex].answers[correctAnsPos].text)"
            }
        case button2:
            if(questions[questionIndex].answers[b].correct == true) {
                correctAnswers += 1
                oneQResult.text = "Correct!"

            } else {
                oneQResult.text = "Incorrect. The correct answer is: \(questions[questionIndex].answers[correctAnsPos].text)"
                
            }
        case button3:
            if(questions[questionIndex].answers[c].correct == true) {
                correctAnswers += 1
                oneQResult.text = "Correct!"
                
            } else {
                oneQResult.text = "Incorrect. The correct answer is: \(questions[questionIndex].answers[correctAnsPos].text)"
                
            }
        case button4:
            if(questions[questionIndex].answers[d].correct == true) {
                correctAnswers += 1
                oneQResult.text = "Correct!"
            } else {
                oneQResult.text = "Incorrect. The correct answer is: \(questions[questionIndex].answers[correctAnsPos].text)"
                
            }
        default:
            break
        }
        nextQuestionButton.isUserInteractionEnabled = true
        nextQuestionButton.setTitleColor(.none, for: .normal)
        
    }
    
    func nextQuestion() {
        questionIndex += 1
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "ResultsSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsSegue" {
            let resultsViewController = segue.destination as! ResultsViewController
            resultsViewController.correctAnswers = correctAnswers
        }
    }
    
}

    



