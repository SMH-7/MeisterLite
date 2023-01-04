//
//  tabViewTest.swift
//  MeisterProTests
//
//  Created by Apple Macbook on 03/01/2023.
//

import XCTest
@testable import MeisterPro

final class tabViewTest: XCTestCase {

    var tabTest : tabViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        tabTest = tabViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        tabTest = nil
    }


    func testNameParsing() {
        var dummyEmail : String? = "Muaz@gmail.com"

        let name = tabTest?.convertToName(withEmail: dummyEmail!)
        
        XCTAssertEqual("Muaz", name)
        
        dummyEmail = nil
    }

}
