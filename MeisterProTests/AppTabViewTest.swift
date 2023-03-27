//
//  tabViewTest.swift
//  MeisterProTests
//
//  Created by Apple Macbook on 03/01/2023.
//

import XCTest
@testable import MeisterPro

final class AppTabViewTest: XCTestCase {

    var sut : AppTabViewModel?
    var dummyEmail : String?
    
    override func setUpWithError() throws {
        sut = AppTabViewModel()
        dummyEmail = "Muaz@gmail.com"

    }

    override func tearDownWithError() throws {
        sut = nil
        dummyEmail = nil
    }

    func testNameParsing() {
        let name = sut?.convertEmailToName(dummyEmail!)
        XCTAssertEqual("Muaz", name)
    }

}
