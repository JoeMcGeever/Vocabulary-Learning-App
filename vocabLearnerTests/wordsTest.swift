//
//  wordsTest.swift
//  vocabLearnerTests
//
//  Created by Joseph McGeever on 04/12/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import Foundation

import XCTest
@testable import Vocab_Learner

class coreWordsTests: XCTestCase {
    
    func testDeleteWordPair() {
        //given
        let instance = WordsCoreData()
        //when
        instance.addNewWord(firstWord: "blood", secondWord: "blut")
        //then
        XCTAssertTrue(instance.deleteWordPair(searchWord: "blood"))
    }
    
    func testAddNewWord() {
        //given
        let instance = WordsCoreData()
        //when
        instance.deleteWordPair(searchWord: "comfy")
        //then
        XCTAssertEqual(instance.addNewWord(firstWord: "comfy", secondWord: "bequem"), "Added!")
    }
    
    func testAddExistingWord() {
        //given
        let instance = WordsCoreData()
        //when
        instance.addNewWord(firstWord: "fog", secondWord: "nebel")
        //then
        XCTAssertEqual(instance.addNewWord(firstWord: "fog", secondWord: "nebel"), "Word already exists")
    }
    
    func testGetWordPair() {
        //given
        let instance = WordsCoreData()
        //when
        instance.addNewWord(firstWord: "mouth", secondWord: "mund")
        //then
        XCTAssertEqual(instance.getWordPair(searchWord: "mouth")[1], "mund")
    }
    
    func testGetIncorrectWordPair() {
        //given
        let instance = WordsCoreData()
        //then
        XCTAssertEqual(instance.getWordPair(searchWord: "noWordHere"), ["", ""])
    }
    
    func testUpdateWordPair() {
        //given
        let instance = WordsCoreData()
        //when
        instance.addNewWord(firstWord: "prey", secondWord: "beute")
        instance.updateWordPair(searchWord: "prey", firstWord: "predator", secondWord: "raubtier")
        //then
        XCTAssertEqual(instance.getWordPair(searchWord: "predator")[1], "raubtier")
    }
    
    func testInvalidUpdateWordPair() {
        //given
        let instance = WordsCoreData()
        //then
        XCTAssertFalse(instance.updateWordPair(searchWord: "notAWordInSystem", firstWord: "predator", secondWord: "raubtier"))
    }
    
    func testGetTenPairs() {
        //given
        let instance = WordsCoreData()
        //when
        for i in 0...9 {
            instance.addNewWord(firstWord: "word\(i)", secondWord: "word\(i)")
        }
        //then
        XCTAssertEqual(instance.getTenPairs()?.count, 10)
    }
    
    func testInvalidGetTenPairs() {
        //given
        let instance = WordsCoreData()
        //when
        for i in 0...9 {
            instance.deleteWordPair(searchWord: "word\(i)")
        }
        //then
        XCTAssertNil(instance.getTenPairs())
    }
    
    
}
