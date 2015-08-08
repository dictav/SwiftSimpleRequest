//
//  SimpleRequestTests.swift
//  SimpleRequestTests
//
//  Created by 阿部慎太郎 on 8/8/15.
//  Copyright © 2015 阿部慎太郎. All rights reserved.
//

import XCTest
import SimpleRequest

class SimpleRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    struct Piyo: Serializable {
        init(data: NSData) throws {
            if data.length > 0 {
            } else {
                throw Error.SerializationError("The data is empty")
            }
        }
    }
    
    func testResult() {
        let data = NSData()
        do {
            let _ = try Piyo(data: data)
            XCTFail()
        } catch {
            print("has error")
        }
        
        let data2 = "{\"age\": 1}".dataUsingEncoding(NSUTF8StringEncoding)!
        do {
            let hoge = try Piyo(data: data2)
            Response.Success(hoge)
        } catch {
            print("has error")
        }
    }
    
    func testBasicSyncRequest() {
        let result = GoogleService.Top.call()
        
        result
            .success { (s) in XCTAssert(!s.isEmpty) }
            .failure { (e) in XCTFail() }
    }
    
    func testManySyncRequest() {
        if  let _ = GoogleService.Top.call().value,
            let _ = GoogleService.Search("hoge").call().value
        {
        } else {
            XCTFail()
        }
    }
    
    func testAsyncRequest() {
        let exception = expectationWithDescription("google async test")
        
        let task = GoogleService.Top.call { (result) -> Void in
            
            result
                .success { (s) in XCTAssert(!s.isEmpty) }
                .failure { (e) in XCTFail() }
            
            exception.fulfill()
        }
        
        waitForExpectationsWithTimeout(task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
    
}
