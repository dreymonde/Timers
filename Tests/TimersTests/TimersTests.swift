import XCTest
@testable import Timers

final class TimersTests: XCTestCase {
    
    var timers: Timers!
    
    override func setUp() {
        super.setUp()
        timers = Timers()
    }
    
    override func tearDown() {
        timers.clear()
        timers = nil
        super.tearDown()
    }
    
    @objc func dummySelector() {}
    
    func testClear() {
        let dummyTimer = Timer(timeInterval: 10000, target: self, selector: #selector(dummySelector), userInfo: nil, repeats: true)
        timers.manuallyAddTimer(runLoop: .main, runLoopMode: .common, timer: dummyTimer)
        XCTAssert(timers.timers.count == 1)
        timers.clear()
        XCTAssert(timers.timers.isEmpty)
    }
    
    func testManuallyAddTimer() {
        let dummyTimer = Timer(timeInterval: 10000, target: self, selector: #selector(dummySelector), userInfo: nil, repeats: true)
        timers.manuallyAddTimer(runLoop: .main, runLoopMode: .common, timer: dummyTimer)
        XCTAssert(timers.timers.count == 1)
    }
    
    func testFireAfter() {
        let expectation = XCTestExpectation(description: "Handler called")
        timers.fireAfter(timeInterval: 1.0, withTarget: self) { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testAddRepeating() {
        let expectation = XCTestExpectation(description: "Handler called")
        expectation.expectedFulfillmentCount = 3
        timers.addRepeating(timeInterval: 0.5, withTarget: self) { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testAddRepeatingWithHandler() {
        let expectation = XCTestExpectation(description: "Handler called")
        expectation.expectedFulfillmentCount = 3
        timers.addRepeating(timeInterval: 0.5, withTarget: self) { _, _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testAddRepeatingWithFireAt() {
        let expectation = XCTestExpectation(description: "Handler called")
        timers.addRepeating(initiallyFireAt: Date().addingTimeInterval(1.0), thenRepeatWithInterval: 0.5, withTarget: self) { _, _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testFireAt() {
        let expectation = XCTestExpectation(description: "Handler called")
        timers.fireAt(Date().addingTimeInterval(1.0), withTarget: self) { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFireAtCalledOnce() {
        let expectation = XCTestExpectation(description: "Handler called")
        var handlerCallCount = 0
        timers.fireAt(Date().addingTimeInterval(1.0), withTarget: self) { _ in
            handlerCallCount += 1
            if handlerCallCount > 1 {
                XCTFail("Handler was called more than once.")
            }
            expectation.fulfill()
        }
        // Extend the wait duration to ensure the timer is not fired more than once
        wait(for: [expectation], timeout: 3.0)
    }
}

enum README() {
    
    func readme1() {
        
let timers = Timers()

timers.addRepeating(timeInterval: 1.0, withTarget: self) { (self) in
    self.reloadData()
}
        
    }
    
}
