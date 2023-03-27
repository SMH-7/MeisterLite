//
//  projectTest.swift
//  MeisterProTests
//
//  Created by Apple Macbook on 03/01/2023.
//

import XCTest
@testable import MeisterPro

final class UserProjectViewTest: XCTestCase {

    var sut : MSProjectViewModel?
    var dummyEmail : String?
    
    override func setUpWithError() throws {
        sut = MSProjectViewModel()
        dummyEmail = "test@gmail.com"
    }

    override func tearDownWithError() throws {
        sut = nil
        dummyEmail = nil
    }
    
    func testDataLocallyForInvalidEmailReturnsNil() {
        sut?.fetchObjectsLocally(forEmail:dummyEmail!)
        XCTAssertEqual(nil, sut?.projectList.value.first?.ProjectTitle)
        XCTAssertEqual(nil, sut?.projectList.value.first?.ProjectSender)
        XCTAssertEqual(0, sut?.projectList.value.count)
    }
    
    func testAddObjectLocallyIncrementsCount(){
        var dummyObj : Project? = Project()
        dummyObj?.ProjectSender = dummyEmail!
        dummyObj?.ProjectTitle = "Testing"
        sut?.fetchObjectsLocally(forEmail: dummyEmail!)
        XCTAssertEqual(0, sut?.projectList.value.count)
        sut?.writeObjectLocally(dummyObj!)
        XCTAssertEqual(1, sut?.projectList.value.count)
        sut?.deleteObjectLocally(atIndex: 0)
        XCTAssertEqual(0, sut?.projectList.value.count)
        dummyObj = nil
    }

    
    func testUpdateValidObjectLocallyReturnsSuccessful(){
        var dummyObj : Project? = Project()
        dummyObj?.ProjectSender = dummyEmail!
        dummyObj?.ProjectTitle = "Testing"
        sut?.writeObjectLocally(dummyObj!)
        XCTAssertEqual("Testing", sut?.projectList.value.first?.ProjectTitle)
        sut?.updateObjectLocally(atIndex: 0, title: "UpdatedTest" )
        XCTAssertEqual("UpdatedTest", sut?.projectList.value.first?.ProjectTitle)
        sut?.deleteObjectLocally(atIndex: 0)
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
