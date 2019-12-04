//
//  userTest.swift
//  vocabLearnerTests
//
//  Created by Joseph McGeever on 04/12/2019.
//  Copyright © 2019 Joseph McGeever. All rights reserved.
//

import Foundation

import XCTest
@testable import Vocab_Learner

class coreUserTests: XCTestCase {

    
    //It’s good practice to format the test into given, when and then sections:
    
    
    
    func testValidUser() {
        XCTAssertTrue(UsersCoreData().addNewUser(name: "Joseph", lang: "German"))
        
    }
    
     func testInvalidUser() {
        XCTAssertFalse(UsersCoreData().addNewUser(name: "", lang: "German"))
       }
    
    func testGetUserDetails() {
        //given
        let user = UsersCoreData()
        //when
        user.addNewUser(name: "Joseph", lang: "German")
        //then
        XCTAssertEqual(user.getUserDetails()[0], "Joseph")
    }
    
     func testUpdateData() {
        //given
        let user = UsersCoreData()
        //when
        user.updateData(oldName: "Joseph", newName: "Joseph", lang: "Spanish")
        XCTAssertEqual(user.getUserDetails()[1], "Spanish")
       }

}
