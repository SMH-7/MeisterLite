//
//  projectTest.swift
//  MeisterProTests
//
//  Created by Apple Macbook on 03/01/2023.
//

import XCTest
@testable import MeisterPro

final class projectTest: XCTestCase {

    var sut : projectViewModel?
    var dummyEmail : String?
    
    override func setUpWithError() throws {
        sut = projectViewModel()
        dummyEmail = "test@gmail.com"
    }

    override func tearDownWithError() throws {
        sut = nil
        dummyEmail = nil
    }
    
    func testDataLocallyForInvalidEmailReturnsNil() {
        XCTAssertEqual(nil, sut?.loadData(byEmail: dummyEmail!)?.first?.ProjectTitle)
        XCTAssertEqual(nil, sut?.loadData(byEmail: dummyEmail!)?.first?.ProjectSender)
        XCTAssertEqual(0, sut?.loadData(byEmail: dummyEmail!)?.count)
    }
    
    func testAddObjectLocallyIncrementsCount(){
        var dummyObj : MyProject? = MyProject()
        dummyObj?.ProjectSender = dummyEmail!
        dummyObj?.ProjectTitle = "Testing"
        
        XCTAssertEqual(0, sut?.loadData(byEmail: dummyEmail!)?.count)
        var responseObj = sut?.writeProjectToLocal(dummyObj!)
        XCTAssertEqual(1, sut?.loadData(byEmail: dummyEmail!)?.count)
        sut?.deleteObjectlocally(fromArr: responseObj, atIndex: 0)
        XCTAssertEqual(0, sut?.loadData(byEmail: dummyEmail!)?.count)
        
        responseObj = nil
        dummyObj = nil
    }

    
    func testUpdateValidObjectLocallyReturnsSuccessful(){
        var dummyObj : MyProject? = MyProject()
        dummyObj?.ProjectSender = dummyEmail!
        dummyObj?.ProjectTitle = "Testing"
        
        var responseObj = sut?.writeProjectToLocal(dummyObj!)
        XCTAssertEqual("Testing", responseObj?.first?.ProjectTitle)
        _ = sut?.updateProjectToLocal(lhs: responseObj, toIndex: 0, withString: "UpdatedTest")
        responseObj = sut?.loadData(byEmail: dummyEmail!)
        XCTAssertEqual("UpdatedTest", responseObj?.first?.ProjectTitle)
        
        sut?.deleteObjectlocally(fromArr: responseObj, atIndex: 0)
        responseObj = nil
        dummyObj = nil
    }
    
 
    
    func testUpdateViaInvalidIdFromFirebaseReturnsError() async {
        var inValidID : String? = "IMINVALID"
        var inValidName : String? = "PrepData"
        var response : Bool?
        
        do {
            response = try await sut?.updateFromFireBaseViaId(inValidID!, withData: inValidName!)
            XCTAssertEqual(false, response)
        }catch {
            XCTAssertEqual(true, response)
        }
        
        
        inValidID = nil
        inValidName = nil
        response = nil
    }
    

}
