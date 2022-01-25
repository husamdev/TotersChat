//
//  XCTestCase+MemoryTracking.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 26/01/2022.
//

import Foundation
import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ object: AnyObject?, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "Instance should have been deallocated", file: file, line: line)
        }
    }
}
