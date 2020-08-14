//
//  XCTestCase+MemoryLeakTracking.swift
//  MoneyConverterEngineTests
//
//  Created by Mikayil on 14/08/2020.
//  Copyright © 2020 Stormwright. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
