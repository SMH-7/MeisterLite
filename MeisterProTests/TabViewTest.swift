//
//  tabViewTest.swift
//  MeisterProTests
//
//  Created by Apple Macbook on 03/01/2023.
//

import XCTest
@testable import MeisterPro

final class AppTabViewTest: XCTestCase {

    var tabTest : AppTabViewModel?
    var dummyEmail : String?
    
    override func setUpWithError() throws {
        tabTest = AppTabViewModel()
        dummyEmail = "Muaz@gmail.com"

    }

    override func tearDownWithError() throws {
        tabTest = nil
        dummyEmail = nil
    }

    func testNameParsing() {
        let name = tabTest?.convertEmailToName(dummyEmail!)
        XCTAssertEqual("Muaz", name)
    }

}
