//
//  QuestionViewController.swift
//  vocabLearner
//
//  Created by Joseph McGeever on 25/10/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    
    @IBOutlet weak var singleStackView: UIStackView!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    
    
    
    //instead, these must be populated from core data
    var questions : [Question] = [
        Question(text: "9 + 9",
                 answers: [
                    Answer(text: "18", correct : true),
                    Answer(text: "28", correct : false),
                    Answer(text: "8", correct : false),
                    Answer(text: "81", correct : false),
                 ]),
        Question(text: "9 + 10",
                 answers: [
                    Answer(text: "19", correct : true),
                    Answer(text: "28", correct : false),
                    Answer(text: "8", correct : false),
                    Answer(text: "81", correct : false),
                 ])
        ]
    
    var questionIndex = 0
    var correctAnswers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        navigationItem.title = "Question \(questionIndex+1)"
        let currentQuestion = questions[questionIndex]
        let currentAnswers = currentQuestion.answers
        let totalProgress = Float(questionIndex+1) / Float(questions.count)
        
        questionLabel.text = currentQuestion.text
        progressBar.setProgress(totalProgress, animated: true)
        
        updateSingleStack(using : currentAnswers)
    }
    
    func updateSingleStack(using answers: [Answer]) {
        button1.setTitle(answers[0].text, for: .normal)
        button2.setTitle(answers[1].text, for: .normal)
        button3.setTitle(answers[2].text, for: .normal)
        button4.setTitle(answers[3].text, for: .normal)
        
    }
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        // check to see if correct like badly
        //also -< page 438
        switch sender {
        case button1:
            if(questions[questionIndex].answers[0].correct == true) {
                correctAnswers += 1
            }
        case button2:
            if(questions[questionIndex].answers[1].correct == true) {
                correctAnswers += 1
            }
        case button3:
            if(questions[questionIndex].answers[2].correct == true) {
                correctAnswers += 1
            }
        case button4:
            if(questions[questionIndex].answers[3].correct == true) {
                correctAnswers += 1
            }
        default:
            break
        }
        
        nextQuestion()
        
    }
    
    func nextQuestion() {
        questionIndex += 1
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "ResultsSegue", sender: nil)
        }
    }
}

    



