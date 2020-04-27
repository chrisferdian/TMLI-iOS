//
//  TMLI_iOSTests.swift
//  TMLI-iOSTests
//
//  Created by Chris Ferdian on 16/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import XCTest
@testable import TMLI_iOS

class TMLI_iOSTests: XCTestCase {

    var dashVm: DashboardViewModel!
    var detVm: DetailViewModel!
    
    override func setUp() {
        super.setUp()
        dashVm = DashboardViewModel()
        detVm = DetailViewModel(with: nil, index: nil)
    }

    override func tearDown() {
        super.tearDown()
        dashVm = nil
        detVm = nil
    }

    func testAddUser() {
        let beforeAdd = dashVm.getUsers().value.count

        detVm.userName.accept("John")
        detVm.userName.accept("Wick")
        detVm.addUser()
        dashVm.reload()
        print("USERS : ", dashVm.getUsers().value)
        XCTAssert(dashVm.getUsers().value.count == beforeAdd + 1)
    }

    func testRemoveUser() {
        let beforeRemove = dashVm.getUsers().value.count

        dashVm.removeUser(withIndex: 0)
        dashVm.reload()
        XCTAssert(dashVm.getUsers().value.count == beforeRemove - 1)
    }
    
    func testUpdateUser() {
        let firstUser = dashVm.getUsers().value[0]
        firstUser.name = "UPjohn"
        XCTAssert(dashVm.getUsers().value[0].name == "UPjohn")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
