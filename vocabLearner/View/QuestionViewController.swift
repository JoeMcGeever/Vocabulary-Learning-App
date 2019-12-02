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
    
    var questions : Array<Question> = [] //holds the array of 10 questions and answers
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
    
    
    var randomNumbers = [0,1,2,3] //holds an array of numbers 0-3
    var a = 0
    var b = 1
    var c = 2
    var d = 3
    
    
    var questionIndex = 0
    var correctAnswers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questions = wordsCoreData.getTenPairs() ?? [Question(text: "", answers: [Answer(text: "", correct: false)])] //populate the questions array
        if(questions[0].text == ""){
            //if the user does not have 10 words, then show error
            let alert = UIAlertController(title: "Cannot play", message: "You need at least 10 word pairs to play", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok!", style: .default) { (action) in self.performSegue(withIdentifier: "ResultsSegue", sender : action)}
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            
        }else {
            //otherwise, begin the game
            updateUI()
        }
        //get the 10 pairs of words
        //get 10 questions + 4 answers, one correct
        
    }
    
    func updateUI() {
        oneQResult.text = ""
        nextQuestionButton.isUserInteractionEnabled = false //disable the 'next' button
        nextQuestionButton.setTitleColor(.lightGray, for: .normal) //so user must answer the question
        
        navigationItem.title = "Question \(questionIndex+1)" //display the question number
        let currentQuestion = questions[questionIndex] //store the current question
        let currentAnswers = currentQuestion.answers //and answers
        let totalProgress = Float(questionIndex+1) / Float(questions.count) //and the quesiton number / 10
        
        questionLabel.text = currentQuestion.text //display the question
        progressBar.setProgress(totalProgress, animated: true) //update the progress bar
        
        updateSingleStack(using : currentAnswers) //update tte stack of answers by sending the current answers
    }
    
    func updateSingleStack(using answers: [Answer]) {
        
        randomNumbers = randomNumbers.shuffled() //randomize the list of numbers 0-3
        a = randomNumbers[0]
        b = randomNumbers[1]
        c = randomNumbers[2]
        d = randomNumbers[3]
        //now all of the questions are in a random order
        
        button1.setTitle(answers[a].text, for: .normal)
        button2.setTitle(answers[b].text, for: .normal)
        button3.setTitle(answers[c].text, for: .normal)
        button4.setTitle(answers[d].text, for: .normal)
        //above sets the text for the buttons
        
    }
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        var correctAnsPos = 0
        for i in 0...3{ //gets the position of which answer is correct to be displayeed if incorrect answer is selected
            if(questions[questionIndex].answers[i].correct == true) {
                correctAnsPos = i
                break
            }
        }
        switch sender { //decides whether an answer selected is correct or not
        case button1:
            if(questions[questionIndex].answers[a].correct == true) { //if the item selected is has the property "true" for correct answer
                correctAnswers += 1 //increment score
                oneQResult.text = "Correct!" // display correct
            } else {
                oneQResult.text = "Incorrect. The correct answer is: \(questions[questionIndex].answers[correctAnsPos].text)" //othereise display correct answer
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
        nextQuestionButton.isUserInteractionEnabled = true  //allow users to select next question button
        nextQuestionButton.setTitleColor(.none, for: .normal)
        
    }
    
    func nextQuestion() { //when user clciks next question
        questionIndex += 1 // increment question number
        if questionIndex < questions.count { //if there are more questions, repeat game for next q
            updateUI()
        } else {
            performSegue(withIdentifier: "ResultsSegue", sender: nil) //otherwise, programatic segue to results page
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //before segue is completed, set the results variable on the other file to equal this result
        if segue.identifier == "ResultsSegue" {
            let resultsViewController = segue.destination as! ResultsViewController
            resultsViewController.correctAnswers = correctAnswers
        }
    }
    
}

    



