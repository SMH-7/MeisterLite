//
//  registerTest.swift
//  MeisterProTests
//
//  Created by Apple Macbook on 02/01/2023.
//

import XCTest
@testable import MeisterPro

final class UserRegistrationTest: XCTestCase {
    
    var sut : UserRegistrationViewModel?
    var dummyEmail : String?
    var dummyPass : String?
    var response : String?
    
    override func setUpWithError() throws {
        sut = UserRegistrationViewModel()
        dummyEmail = "test@gmail.com"
        dummyPass  = "testing123"
        response = " "
    }
    
    override func tearDownWithError() throws {
        sut = nil
        dummyEmail = nil
        dummyPass = nil
        response = nil
    }
    
    func testcreatingUserAndValidateIfItExits() async {
        do {
            response = try await sut?.createTestUser(email: dummyEmail!, password: dummyPass!)
            XCTAssertEqual(dummyEmail!, response)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        let delResponse = try! await sut?.deleteUserFromTestEnvironment()
        XCTAssertEqual(true, delResponse)
    }
}
