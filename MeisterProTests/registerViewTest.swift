//
//  registerTest.swift
//  MeisterProTests
//
//  Created by Apple Macbook on 02/01/2023.
//

import XCTest
@testable import MeisterPro

final class registerTest: XCTestCase {
    
    var registerTest : registerViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        registerTest = registerViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        registerTest = nil
    }
    
    
    func testcreatingUserAndValidateIfItExits() async {
        var dummyEmail : String? = "test@gmail.com"
        var dummyPass : String? = "testing123"
        var response : String? = " "
        
        do {
            response = try await registerTest?.createTestUser(withEmail: dummyEmail!, password: dummyPass!)
            XCTAssertEqual(dummyEmail!, response)
        }catch {
            XCTAssertEqual(" ", response)
        }
        
        let delResponse = try! await registerTest?.deleteCreatedUser()
        XCTAssertEqual(true, delResponse)
        
        dummyEmail = nil
        dummyPass = nil
        response = nil
    }
    
}
